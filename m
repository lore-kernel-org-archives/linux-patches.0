Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829278;
	b=eDlbFKGclvg83KYODNvJerHMjCQxZnc/4017Xz/VYWLb/WmvAhBfRyRIZahB7in4D3JA
	 ngzxJE4jf1l2HLvv24BiGTvMJhfMY4etLSUX4tvgvGsBZ5d1VCRWA5wcumM5x/if6JKdZ
	 lXx8AlxIf/EvfEG+hWHEsVjOHO1q7n2LVPJWC2ucBAwhyt45vvDp06p3JKheYKfjYey1u
	 71zP7UgZ6s/GwjlS/NRTSUUmrBChY3i6mY3miD5Vep+HbAsYsh6mado/ENLW7np42bIaA
	 3iqv7iOe9DlCUJRR8IW87vxhbo5HkQnH13UyLeol194xc61RD6btsnYUZqPvgOE5WLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WiMg2IY5t7KTZSanbzGLQarYVVZVilXxieXymDz66zs=;
	b=fi5Rks05EPFAdPWLrHIE9sAufjME9vVS7VzyYTfRvn5jBqcRMJW11EIh2IylRW/WkvID
	 +S0wqMg98j+SBny2J3Dyv1oLiQBpJVwujGa5nihLmt98qO25oSrndrERTHNIy2gWFpxxk
	 DSeyOK7chqCx6iJ8Em5szX3tVwqOXZmsvLzimD8oveNiEvcu4NsH9PhGQSq4d6H1WMqsg
	 2sbPJfoIEubJZzWGTaS5kAgJIP9EgCvqq+0U2ehiVGD2c+5VUY7WiGa7HI7MLbcEZHynz
	 RLALGp/2it0hC8YdoNWJ9rHHYArnWO5TVrP3S3NIZ1xLbQ1TV1m3frXbAz6Ovso5c3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTo3EoJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4930560745A2;
	Wed,  4 Nov 2026 21:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTo3EoJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B7F1F000C1;
	Wed,  4 Nov 2026 21:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829278;
	bh=WiMg2IY5t7KTZSanbzGLQarYVVZVilXxieXymDz66zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTo3EoJC0VfCQSSIHVqlLEIAIiK/BYEQ+eQFxnI7ToNhNHwGp5FZElt+Ou144dtdy
	 Ad1YI7VMI94RIfR4CdhEMHGZrOq+oFiccxztNr8zRdO46cbybn3LWgxkjlgCoFyS58
	 FfYVJnfEsa7eHKDC1fXC1TmmcH6+wRHOz9f/+w08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 514/547] HID: hid-lenovo-go-s: Add kobject_uevent notify during reset-resume
Date: Wed,  4 Nov 2026 16:11:38 -0500
Message-ID: <20261104211052.994770093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 81e8c0bb3831fb84ef44417bba1b52333d0580a9 upstream.

Adds kobject_uevent notification after setting os_mode attribute on resume.

Fixes: 3524900cc571bd922a ("HID: hid-lenovo-go-s: restore OS_TYPE after resume from s2idle")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -1618,6 +1618,7 @@ static int hid_gos_cfg_reset_resume(stru
 	if (drvdata.os_mode != os_mode)
 		return -ENODEV;
 
+	kobject_uevent(&drvdata.hdev->dev.kobj, KOBJ_CHANGE);
 	return 0;
 }
 


