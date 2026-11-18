Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044844;
	b=slgyBKA05wCkebCCf0qBmx0XC8J/odZpk/pTa6BX7cBwVy8VliIf7BOQ5k0aJoEc2JM+
	 AjFON/fG2Wk49YxZj9fvGbvIy67zwYqXAt5rDHsrbYOy3G66VeucA+EX9w04SB5Ft4AtE
	 dPehu48C4NJNai7IVG2g0s7XiAckGZQ1dGCkz8FamW3TLCfeNWyDz2LHXtnBwdabJdzZs
	 mEEJmBAbmmIf8dHfYeWHh3V4EIExSaef723Xj/3EiuwrV/Qy90UoyAR389Ejoa5sz4CQg
	 ryXa5b6MKR1vpXOi4OjX7oU/rQooawsMQj7CRtfuxq47YEYVZa3fa94cjCxMfcZLmfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6NUmGoF3+zuRVK6hhiQSTFfgSuJ5ra1aLAw9MXfr1A=;
	b=j/9HbSRjvoxm4Hbvteq3hip0gsUyHg65R1Jdku23nObhgxWppHDFMgBEO6QOVfIKVamR
	 X/DA5m0UO1TwZMeJhQl4my80A43M9OiVNDbIfdVNUpEVCuG5KnDJzXHTzpY/SsnsFIUwY
	 E27VufPxRcpa3CxpN9MNrhzaMvcQPhkb8XENhqrTBdkhBPw9W24Pi0agW00OmcvH229cQ
	 dIG/nwWdtniBe7R0jFlVgLMXn7bpzLEGvpXijy6Cp7If+FVXl8jHFmz5VrT3jBwVyycmQ
	 woiljbVjy799+3It5wQhU0Jx9lLXqTzsDECwRXlcIHaTagLRuVDCHb1AMh/QFzmO0IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5DbH3vy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0FC606A9C1;
	Wed, 18 Nov 2026 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5DbH3vy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9371F000C5;
	Wed, 18 Nov 2026 23:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044844;
	bh=v6NUmGoF3+zuRVK6hhiQSTFfgSuJ5ra1aLAw9MXfr1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5DbH3vyMbJIuz7yVnH8QjJp9wxpBXfNUi2Xk0UdoQR09MN6uPXl0t0qLWbg1ES6c
	 QJp6y1xBvAmeRfCJzkRsda+X1/yfLdEyyyGupTBCYMWvCAUOHvD7zqnYHOT4Rmjx/N
	 w/ryyfVAokb3MIVweOt8ZvpB8DwDnIyDIoPRqIhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0711/2857] media: redrat3: Ensure all urbs are suspended
Date: Wed, 18 Nov 2026 15:29:05 +0100
Message-ID: <20261118150227.150132822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c0363be118f2f..db317c6c62fe7 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1168,6 +1168,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



