Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061775;
	b=sL33phk+I1ia49GgYKvrYhIVtF96hRqJMDCFDi6FyQfGy6IxJ/aa6U7YGo3awuv3VMFA
	 I1z3MwT4FUpxyuqm7GskUQHWH3b+HgcfIlI5GNbPcVscyWSDXdzyypXJo+xg55sW0uSZQ
	 Pv/zUpJsCQML7MDeoPBoMSDY9bgqlg+xkLW14wiqd66TOCw6XYjSFv2iUabh3Vi775cEx
	 JRoRXreusUgL9tqbrX7xCO550FCnK9Bl/UdL5e8IWXOzl48yNVNh801tdIBoXAJj5rqzb
	 p2r3mwbnnr/Z3R8Kgp2EpxRztf3M8vy56Fm9ftiEErUNB004Dn3feRv7FDedyESb9Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1knR6UOmHNfpuTHQLpd+irOSAk8F3rIfejxqGPLdk4=;
	b=NuQ4mPLK7lLFYjK4xSFLBwCmrsIrJa9clXnoLsvtomUhi7uZKZraOOxw3wyQO9lwDiPy
	 uVCJ9H0ixUdJqP/5ZMo6ZPBPh/zPIO6sq4a3VoNB9p8z7ZnN+gsJ/Jl76VKmL6VpQpY2c
	 Ds59HpiF+e4k7DMC3GIzccP8TIA1GzknqKD/fzKGXlvKoVq4RmQEyjMc3XyTxhCynovcx
	 O6SKWV9YpE/T8Qp9praJmfsXIAr9s22VjnbtQJSJzz11vU+DKCezoC3P3Q7bEyPb+qnX/
	 sJLFeatnwVDXwgbybCikWRJduMu9rKxi/IiaVEsXT2KXVa/h3V78GojYDeuxIX+mY4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rdN9/W84";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8835C606A326;
	Sat,  7 Nov 2026 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdN9/W84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DC71F0089F;
	Sat,  7 Nov 2026 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061775;
	bh=g1knR6UOmHNfpuTHQLpd+irOSAk8F3rIfejxqGPLdk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdN9/W84B9y9pFwbnKbZi/jU5k9kokDrmFFx7tfG+3NdO5X/1O1a7pu8WhLlyxMan
	 N2tIer5NuOOBLxPlWfnug1qUlL0qGl6/lH7GvYNdJvjjXca6/VoTDlX0pTSxGRpGSu
	 XdpAWH7G0ZoexWpPf1/iDCMjgnVYHuq0FWVHZaT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0808/1536] HID: amd_sfh: Use report type from request node
Date: Sat,  7 Nov 2026 08:47:04 -0500
Message-ID: <20261107135020.239075400@linuxfoundation.org>
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
@@ -95,7 +95,7 @@ void amd_sfh_work(struct work_struct *wo
 						    cli_data->feature_report[current_index]);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 cli_data->feature_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");
@@ -104,7 +104,7 @@ void amd_sfh_work(struct work_struct *wo
 		report_size = mp2_ops->get_in_rep(current_index, sensor_index, report_id, in_data);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 in_data->input_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");


