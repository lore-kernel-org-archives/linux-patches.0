Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044617;
	b=dMz0+DvoRbUwCwJpjCF+DX/OHgG/Cpxx6IqbaXb4Eb64RyrmgzcyywwOAa29ZF8+88+d
	 xQ9eXJK3NfYKhT9PPLzbbBxMgyK6t+277ZY41fgcJAphJVC0/H2z+egl9vtnLbQu9qdXM
	 7DXFrZdYSAAl/izgpkQDXjfJQDo/5IRnIIr7q1//J/pHW83CWzBhMJCsinAG/WvgE4UYU
	 yjpKuRr3fIZRABCQ8FNCc15sW09x84ebbFLPLLaq8nOxn5lI270mM1lewLOMgMn3KdDRP
	 wLAFkS0SIGD8sqYiZeQtOyo6Hlp0Er96mUZY/noMSFVksCnmpLRdfLJtFJerXeydYFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZiIXKBoQmO2rXvRalLZX6BS0yXUVmZHwLHtiqHcx8BI=;
	b=i9isw0qLSaFAyWLL441yVb+NpnFaVg3PGHo9Br3RVijmPiym2gUXqDDnaMWPmn/U6Nn5
	 SdGC51TmMMOsBBfzszc2JrUhfmmwYAy3K2bOnSPx1FDMFcrCmYTaKLyuSVgpMsTWQGKzj
	 rJ7hPnsLHW3mVs1n3aWbGtult02840CjlJN+upYTQ13dqTTZNQFqtWNRM6LnGm7nrPwP/
	 vHnOCFWTaE25P2OqBrXZPSgT7gqVU2O6gS2ZatCZokdKKgDluE8C5U79xSsbts9FS5LMN
	 kP7wbq7E9EqmanRz2sQMIicuVxqljXV4LWlblYPFyjZueezL43TrCpsPCS+KoGPpXsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iR+RjPn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F69606A333;
	Wed, 18 Nov 2026 23:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iR+RjPn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ADE1F000C5;
	Wed, 18 Nov 2026 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044617;
	bh=ZiIXKBoQmO2rXvRalLZX6BS0yXUVmZHwLHtiqHcx8BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iR+RjPn0PFW+T1TWIMZZEFp2FVS4GSJGBuTiaY4lWvqeYgp3QW+4bDsih0ZgykSth
	 HevmSYHxUe3+ST35XjHdPBh4FKwRxFeDMGHGhcbMGuTWaWoCie7fOrTkjT9d3iefwt
	 +aSnEnZ90l5m8meX+kZnNDKXbQ0JhVMcUGzbKkFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0632/2857] HID: amd_sfh: Use report type from request node
Date: Wed, 18 Nov 2026 15:27:46 +0100
Message-ID: <20261118150224.256902989@linuxfoundation.org>
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


