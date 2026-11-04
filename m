Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829163;
	b=ky7TRNB2FBSy9opJOlH3KBcvj/VG6IgBq/j+S3Pq5cS/KDyrjNDSvaTce+a7kgrtgIc8
	 t3Um5ceBQhMVyFD9Y5cf1hbGWBIohNporIPhGMq64LMQM8pfk7SBH/8pqBN798WvHta/A
	 fJxdV1FaGy6SjEp226G81tH9b3x4YDm+Af8uix6gRPxQhLshC8kWtwa2G8q/7nPY5tjGM
	 PfoXBD/J2/JjsvNrWgOrQ6J5K5kIlwBLwRGRtVNhaaeMAoZlzvs71A1wu+FvQaZ8kjQao
	 qb8AvBSy2NZs9zXM1WWD/ZZHhguwu/8QDHSndmwMkhAMr76TFUBULfOQjxKsLzmQsEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtA9mhU6Teu2QpnMc3+IsuGAKVGtXmE0GsRPw0grnQQ=;
	b=5O8aK+vg9tgixSJM5GFRc7QGwFw5ISzKXYIq5zuFp3cdVWjLrSEgafFPYSqFUep0L3VF
	 7iZ9jRQAMp2XPosxDQs4bdusObP6GkCafNc5XxZtFG728ygi7AzuN+ajre0YH97Fzj4tF
	 z3p3uucMvyQGn+6T21X4nfFirmo9YTFkziGpQztqw0hH0/2FZWQxSaI/olQtXA6r/QqBP
	 kQcPSHdKpp9VwZciqV9VQDT30i1xhrJY9jD97sQ2uO7ZH5qi4OaCWFn36UuJlhvEEG+ca
	 /oVdaVyUJYG3SIXmLV6Kb4lpS0Fvt9mRbVloMUBP62F8K9KqmEZEiwOUlbYlFLXsaPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZGkqChh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9DC607031A;
	Wed,  4 Nov 2026 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZGkqChh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15B41F00A17;
	Wed,  4 Nov 2026 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829163;
	bh=NtA9mhU6Teu2QpnMc3+IsuGAKVGtXmE0GsRPw0grnQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZGkqChhTDE//M8H5CoqX+BKBZcTAVBXaHBm4UVeJjnuQRreBOcb30d8eTF8Bzch7
	 6fJHx45/SOLDVT2sWkkDLavcc4Ye7wE3Y///ktHPROGOvQgVSGKq1iwtDZwvhQp9ws
	 JI4/dLzOSghnNvk4GISiTahzBBAA2CORjb+o1lEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 486/547] HID: amd_sfh: Use report type from request node
Date: Wed,  4 Nov 2026 16:11:10 -0500
Message-ID: <20261104211052.186159879@linuxfoundation.org>
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


