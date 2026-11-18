Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052036;
	b=qOvwDnEAZJP8sT6wOtWiwsuYt3s4aMwqJwFCnJzmdnsPXfvzk1K8HiutKBAEC49MLd7a
	 wfJszyGFBtDEKSy2amPda1AFx/IzVrL+p1/fM9ynKrZg+iL5rhb1K5Mmc5sMcP9nJnLIh
	 KlFb7/eOzpdw8sitewAGkG3K031EtBekd3CxdM+rnd5qXgmPO9jKEGf4XjZI+dw+nZ7N1
	 QP6n04z4hCYgwx7Xye5EfSjU19oxjEh9TDmfXxPoBaMKvmGEMLBd0x4ZNEkr/livanNT5
	 WmIJlDKMtdbR+VDEdQBZ/1+Ml4CZ8+mzd8fRASbCWit1Qi3aKfITiEoaYSpSCHgtDXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X57dvRmViokUzCXjPnx+C4cZU4L3/cd4uYbVkD7KUHo=;
	b=u7iLfCtMQsD3qW2n9QJR8gvgc8mYeXKt3TDtviFQJJnQfAq/f+w5M8syt4Dr4ipTPS/w
	 iA2BZDIx7IWTYSMnHyzy6tOEiyESumkx3XqotaovfRlu/EPXmjpsL1hF15BfTSs8dOlh2
	 PwvdmbMcx6pO52cVOLJiRL27Z9b3TVUgcwpu1PET1aYmSmOfv7fSszhXAVZhZo7W3wuNa
	 zUoOxmjPgcgVNg4/mA1MkOTN7nEWkC7D8yF94eB7zVYMFzb8YJ25y38iVVUY3WDp8VxTg
	 8UOmg17SwE9KTqmYqyUiCHhAeTV/ddUFxWme5Nrp8FF/S3aY81FRmvOsA4JgySV0w3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWIB4rwf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40276606A31C;
	Thu, 19 Nov 2026 01:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWIB4rwf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966041F000CA;
	Thu, 19 Nov 2026 01:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052036;
	bh=X57dvRmViokUzCXjPnx+C4cZU4L3/cd4uYbVkD7KUHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWIB4rwfzyH96/8jEv94wwZsmoCVWLPj3OWp6X44A9vCqVZfFzB+9r3H0LYkAMIin
	 QOYvsdr9fL+hZwNKNrHsbFojf/CDmIuyMSmylHk2sWduZABj2tFuZ7/w4IxYOC/L8c
	 3q1jqF6VIQLiXxqsFWZiHO0kzHTebxNuv6PNO0LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0371/2214] HID: amd_sfh: Use report type from request node
Date: Wed, 18 Nov 2026 15:34:07 +0100
Message-ID: <20261118150025.570681047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,7 +95,7 @@ static void amd_sfh_work(struct work_str
 						 cli_data->feature_report[current_index]);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 cli_data->feature_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");
@@ -104,7 +104,7 @@ static void amd_sfh_work(struct work_str
 		report_size = get_input_report(current_index, sensor_index, report_id, in_data);
 		if (report_size)
 			hid_input_report(cli_data->hid_sensor_hubs[current_index],
-					 cli_data->report_type[current_index],
+					 node_type,
 					 in_data->input_report[current_index], report_size, 0);
 		else
 			pr_err("AMDSFH: Invalid report size\n");


