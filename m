Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831909;
	b=kdkLWNKQ7G+iuPQjQZUmp6QzMccf6ppP4F9Vf04GbSJN747CEtMOEsWGZ/K31zVQ2ex6
	 fUA3FHCwE4uY0VloidW2slyA3IhI093tM26QCdEyh5Tn0UpR3AJLeFwTgDv+2lDW7SM5E
	 x4oaU25WabdfUIXTX0maXgv6jXTFJuuv2uKvNN3AwLdme13DYLR9fZNBRIa7vqcXpTHZ/
	 4/jZ9NTuKLByMUyXSkt3jcwpPfhpXeBb6IoCN5U9grRE9BVOClnnKJnQndOdR6Mw59eri
	 HFps1AvgkmnRBq9tkeiMznK+zN0VdyyKBWnjLPiPfNkjJnpYwEE4Au0YM1k1ZcGjY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ymxcNJmzJBQhKAboIiJmm5c+81kcJpA2uBWGmoK3hzw=;
	b=BSS9QInjCadT0uuMv7D7NiiOw0Yu8sYFQCGY2g2X28Dm7kIXoM+WKmy5cHUil+FoI3eA
	 db5CysUf05HunnjF2ouwfBntV4tqtY+uf8RKAZIDDCwx6QMQZdZCq0Bv1R7TGi9Irfkhn
	 2CgNYJTARNIWBTyOesEpCRCmRjv2lAE4Lsp6rDeXwD1ToLNftPy3YTEcYV2spv9plZSxh
	 lTPTVNyH3LDpgMSTElRCJyOg/dkeqM+KhsvByBblwjyz6ahBAX+Hv88yLWVP1v6DC96B+
	 qkB0Dh8gdGg4V89cBorAOH65YQ6rppzAdo3NgyufuFBBixAZvUrxI2efVDwBUmdjjPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h6/KNw8Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A2606A32E;
	Wed,  4 Nov 2026 22:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6/KNw8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8131F000C1;
	Wed,  4 Nov 2026 22:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831909;
	bh=ymxcNJmzJBQhKAboIiJmm5c+81kcJpA2uBWGmoK3hzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6/KNw8YmTzp8O4UBqJPDe+arDkv6/VntWmXygpBuRZKuhMdZW5j13D6YxPBuWwxm
	 uLe4zsK63SqfrxKcpDz6c646adWZ3gUokhskoDHLeqaCuS3PX52I4WIohMQWd9+HJO
	 VFSifRUpCJg6rX8x5syJcVTxX1sCLa2PODRptx4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0947/1005] HID: amd_sfh: Use report type from request node
Date: Wed,  4 Nov 2026 16:11:20 -0500
Message-ID: <20261104211109.639138969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


