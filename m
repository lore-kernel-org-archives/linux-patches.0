Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00C71DF97D;
	Wed,  6 Nov 2024 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895795; cv=none; b=llSR8AzS+xpFlG0JmNnyERtHtIiad2byVgYNLMpUl2F6UfJpTuGn8SJgHbHJeb6mRJBirD58oTRxJLbGSsY9uulqwIBc3z+QXMjgjUdh2fpU72+nUweS4TiymCl/77Z9fji5+fVPdhv2KTfFrAKGatZ3hn7zNILJ/lfZ9LhuZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895795; c=relaxed/simple;
	bh=BYboYBAc3zQJckQ0KWMg1OOBUGUik064wJxFSqiAXXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWgegVmeOe4u0rQN3/ZgN29Y+Kj/fgUwDg/v3fqR3iTSBZ2XjJQA916ONuc5bSmaW7YVtCez0fikWkAyQoUdVFT9aV964A2bamXQrCopb6YyTxUJNgAslxCfDENEoOonAHEn81F+6VL1+s6JmB9Q73RVytKfbxab0SZhbNBDLBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh6Y1hQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh6Y1hQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7CCC4CECD;
	Wed,  6 Nov 2024 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895795;
	bh=BYboYBAc3zQJckQ0KWMg1OOBUGUik064wJxFSqiAXXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh6Y1hQBy7h9v6CZcYNGE9TadFGvhIZCxauPVywL9uRs2sjZ2kMljto+jeJH4b7Pu
	 oOcq/DBFmyUD7aXUUuWHU+asROss6re43BFl7nr9Jli0jqt2ezlb5+mqvB/E4uMiyo
	 +xPdhePo3aRrgmDgkWWtAeEVsplcqKCuanR6cATU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongren Zheng <i@zenithal.me>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH 4.19 339/350] usbip: tools: Fix detach_port() invalid port error path
Date: Wed,  6 Nov 2024 13:04:27 +0100
Message-ID: <20241106120329.076036484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

commit e7cd4b811c9e019f5acbce85699c622b30194c24 upstream.

The detach_port() doesn't return error
when detach is attempted on an invalid port.

Fixes: 40ecdeb1a187 ("usbip: usbip_detach: fix to check for invalid ports")
Cc: stable@vger.kernel.org
Reviewed-by: Hongren Zheng <i@zenithal.me>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://lore.kernel.org/r/20241024022700.1236660-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/src/usbip_detach.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/usb/usbip/src/usbip_detach.c
+++ b/tools/usb/usbip/src/usbip_detach.c
@@ -80,6 +80,7 @@ static int detach_port(char *port)
 	}
 
 	if (!found) {
+		ret = -1;
 		err("Invalid port %s > maxports %d",
 			port, vhci_driver->nports);
 		goto call_driver_close;


