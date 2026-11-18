Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035496;
	b=TNR7yYuBsJo8jJUTdnKYVT3bm3eu4QtTuAeRS6/z1jCgAnusSTMVV6qYhBCt4lNsY913
	 6Re14xpIsXJKagUN5lywcO8EZ9eDEukKwLDpVx99H15jVTLxu0U4aSjN7jBlk6b2xwiRH
	 j3/hpHjD4pcIaBGOFUrCvhrBr1piGiiIiHS8AFb8rSOdUoAV1y0ygeDv00JACMnmPzqlP
	 gQcHwfHUmSlvH478LSnu/JHw/ee7xrwtscsWJOn7UZDQ/7BmtIrcJjoII3zvQlTq1XjCB
	 fZt0rwkJBf/Gr+VHb4GOQ5aKiDR+9rv26XJ90T/4CH6889eJVxrxGlFw33y+89h4k+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EjXHAfiHaSEVRS5ElbZGQsBJpBSqdSDP0Hjf0njoEdU=;
	b=JgzbQc2rustuQ75CpIwckwALAoe5roIcIr8M28vVWFyd6Qg7TAa0Jl07sRK4dldXAICl
	 e1rJZ0pZLMZBduPaZTrwrIN+bJ9KOVM5XIwtrzwmUX/FUNUqWk3f79mDZCq6l0DX1k/+v
	 YZdk12wUZuD5yNlXa7pVyF4QvktYqqcZ9Qf4CMHo+MQyy7cAuRQAlFbiTQQyIHSroYXRE
	 gT2CmhbQIsWo7mY/AQmrwqYiVNQQjaae6C1SobWcsv5ZZVUNT2V4ByrR38HKkVHi5jfJI
	 hu9ybE3arjb8vMoxz4Fdm+EM7ur6FdSTiMLgpnl98wQBPwaWZv4tGLGRafVNEGQgAOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGqC47+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D146606A320;
	Wed, 18 Nov 2026 20:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGqC47+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C4E1F000C5;
	Wed, 18 Nov 2026 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035496;
	bh=EjXHAfiHaSEVRS5ElbZGQsBJpBSqdSDP0Hjf0njoEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGqC47+i4op3lPwlQhAn9LGFFlyYR4UpYA0uTJ8POAUzzQTpuMhvCurX7+/fYw/9X
	 N+vySfHdA1B1ai84OsulICcL/2KllkAKQCH8paFsq+QDJOCWGyuCc2vgk4MEk7m9/h
	 knv78BJd2eO2w5bMm69topYlxXjr+TO1TRB8BHz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0724/3318] HID: amd_sfh: Use report type from request node
Date: Wed, 18 Nov 2026 15:22:26 +0100
Message-ID: <20261118150340.223915774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 85f1bea97f1909f81577cfcf3e4db9017e7f5337 upstream.

Use report type from request node while sending feature and input reports
to HID core. The cli_data report type array is never assigned and
feature reports are sent as input reports.

Fixes: 1434f9fc0e47 ("SFH: Create HID report to Enable support of AMD sensor fusion Hub (SFH)")
Closes: https://github.com/ublue-os/bazzite/issues/5796
Cc: stable@vger.kernel.org
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -90,7 +90,7 @@ void amd_sfh_work(struct work_struct *wo
 						    cli_data->feature_report[current_index]);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 cli_data->feature_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");
@@ -99,7 +99,7 @@ void amd_sfh_work(struct work_struct *wo
 		report_size = mp2_ops->get_in_rep(current_index, sensor_index, report_id, in_data);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 in_data->input_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");


