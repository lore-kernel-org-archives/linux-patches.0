Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062035;
	b=X3mMZKGf5NqPIt2M++qtIIeW8S5emZ8ExX+OpP+XdISD6bdW5Rz/PyRy2uubtrTg+8gK
	 9kwpmyr+Zaw+DuBxyT60QQc8WAVi6mKBzt+wyPFGjJ4XQmZtcQJ+Dt42Lc5P5B1Y0ZMFQ
	 bEM65/a0lyTK4Zd1VCL2ItdgJbQImCx4FwXgJwsIwT0CV5VD/3q0BKFFeoGxLWYwgjZhy
	 fA/NN2DVqaBshkZ7qkOEJPRHgkbXIB8Dfli7c3HHMtQLAzvsezQEqFXe0LNSeD/JJZ+aC
	 MfWMbfCnoLWQoTFnRYZe9TcMMysI/pbSMUL7sWmYCxxP1Ur9uxMTwDwvnAPtUoOkFFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLTM+Vsxho+4I4ubeq7ErCldRKMqcYRQLHJpEr1sMQI=;
	b=HBFjiTKZLOahCksZmtIyWjAVhtuH7GM7MRHhKTA6e0+Qz1Ft+aiqDVE5QUb1Gn5C+gTh
	 SkMoFVUNjLUEigz03LlxlGIfKV+bE4jPF4QaY2JitcCf+IfOYv8rdEgjaMGsyvjlnKF/D
	 lgcPsls1bU0JnsP/hiZ7v7KS64LP79rY5drEG3jGHgf/SEtDjeUuBIBTVAkrnn4cgkFW9
	 zmvDaOUDxbcdw6mh0sZ/CWIZ9Tndf22crqtGNUAkFY6RXIYu+EDuIH8ovwtNKHxv8q6jv
	 5viCU2WsRROscwqMawhNgMybeqp2pO6a7+mcKwCWVIGVpjkEJfyuDlVEl/3dWeAWlUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+S7PFCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03188606A332;
	Sat,  7 Nov 2026 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+S7PFCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52821F008A2;
	Sat,  7 Nov 2026 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062034;
	bh=xLTM+Vsxho+4I4ubeq7ErCldRKMqcYRQLHJpEr1sMQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+S7PFCmfJNiSw6zEtVKWvc4hj24LTJri9DN5tnK+M4Q4Nwsr8BDUt3XiS+YjcmDi
	 ulbdY8uGOIaOYzmfXLvbQbG4QqMYPWgPiSIQLp7U8jQBhTVOZzKllsCrvTiOGgMC+1
	 9tcb1NHhbMT2LYBzL8NDDiEF2Klelh+lXWy5FRY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1018/1536] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Sat,  7 Nov 2026 08:50:34 -0500
Message-ID: <20261107135026.272435490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 05d9c515cf13056875abbf73adb4a19dd7ba32eb ]

If an excesively high carrier is set, meson_irtx_prepare_pulse() will
cause a divide by zero if tb_us is 0. Prevent such a carrier from being
set.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 1ab898069e67f..a0d07da09f67a 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -219,6 +219,9 @@ static int meson_irtx_set_carrier(struct rc_dev *rc, u32 carrier)
 	if (carrier == 0)
 		return -EINVAL;
 
+	if (!DIV_ROUND_CLOSEST(USEC_PER_SEC, carrier))
+		return -EINVAL;
+
 	ir->carrier = carrier;
 	meson_irtx_set_mod(ir);
 
-- 
2.53.0



