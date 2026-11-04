Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829200;
	b=5UQHBfgX2rLJ+uIUfooLULXsQKZn5JOgwQRdOHfbjBefI4FEMoFJYvxWDbJ8sNYo5ZAR
	 BSwLUV8gVoCJm+nUe0DjjJGqeSsvGYYz1cwY2lb0xzBnbuIS/Ob7oGkDBrB5oTXfHFN6l
	 ns09VR0lca8Ghwjpw+uLFT/2kG/Vtv05kaczxEleT0D4paiIil/JNNioor9gWdMPjDouS
	 Rc2O3L1KsXKFHv1Hko37lfkKAEMSreWG+JVY9K0w+kElgcXTyOQvLKI2iIBUNC8ldLmE7
	 m3U+phDxaeVUYOf7uMdhwLopACKHUoekzIMDZnSundYb86CGDApi35cmT49+U/sEUww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3xHUtna8gyUWdITc09dEfN+N6lwKNBrShhCkR7I9J4=;
	b=2hzr3DVmuQtslwmH1inRR6RHJrep5eUTjZJaitGEmVumbc8eUvIhPKuynTcwNmifGrJK
	 sED+uaeKh//rsMG/D/WGLjpsHQ9pLcI0Oj1tIrziOg1YI76xt0dwcgyMknUFq4AgkBoMN
	 C0CWEIGrqURbO6PJcxY3IjclPInqim73RtKazypOwUc1J9v8qHCkIsRZf0/WdzLMbZ0bw
	 mecivmnrBg8EqeWodHyKUQQTYFpBSxPLtmj4m+M9RESGBFYweeEaAfO1f+1o51vJ39E1a
	 oXAY5jVVszWgv3jZ3afd5CWR6bKbtprbOFOLsYy4vY651y/JhpM1AKt27ORLI62EzvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2ep2QpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85852607030E;
	Wed,  4 Nov 2026 21:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2ep2QpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7D41F00919;
	Wed,  4 Nov 2026 21:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829200;
	bh=Y3xHUtna8gyUWdITc09dEfN+N6lwKNBrShhCkR7I9J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2ep2QpDoHkxK4M93jEtQfMclpX31KglUBxGDQKovxU8Z/Hqnn3p8D+DFGYFmgXUg
	 xPLydW+9k0Dea/nOgNwXyxF7dZsU+YQ6iQ7ZGyO68/ahkl05NR7X0qZEPWCTvaqv51
	 k84+jz4FckfawsmCT1yO0syfWqMrqF2/EnFQ+jFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 509/547] HID: hid-lenovo-go-s: Use pm_ptr for reset_resume callback
Date: Wed,  4 Nov 2026 16:11:33 -0500
Message-ID: <20261104211052.848647023@linuxfoundation.org>
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

commit 5c07247116ff749e09fe45cef439d7b2b66454b6 upstream.

Adds missing pm_ptr to the .reset_resume callback for hid-lenovo-go-s

Fixes: 3524900cc571bd922a ("HID: hid-lenovo-go-s: restore OS_TYPE after resume from s2idle")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -1540,7 +1540,7 @@ static struct hid_driver hid_lenovo_go_s
 	.probe = hid_gos_probe,
 	.remove = hid_gos_remove,
 	.raw_event = hid_gos_raw_event,
-	.reset_resume = hid_gos_reset_resume,
+	.reset_resume = pm_ptr(hid_gos_reset_resume),
 };
 module_hid_driver(hid_lenovo_go_s);
 


