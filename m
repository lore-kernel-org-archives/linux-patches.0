Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D52A15B0FE;
	Tue,  2 Jul 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940292; cv=none; b=JiXpSWomyFR9MqalZZ2CClKMz8bQ6qzuukJVIlaPy8T0mycWaQbcjUA1SdXR4szCED5OnXt56rJgsBJOIAQJH5f27+9hSTQEYD9MtDz6hLGSlsn7KC12zl6/3cHpfQJXL/Ux+OlL9zeFax/HT3fxFB/3ztMqfCnombnE5d5y46U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940292; c=relaxed/simple;
	bh=NoP3/PO1nQ35zfmG/1hSeiUBQiBMNDGSUO4nQJJCTBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYmfIQhqZ/kpd8wWIAwWjVoLpTJhij1nm0DkNP1D16HLwKq1Xsi2eiXwCMa0Fr1boHqrJaFQ4r1CtRTh/k4ZUKV4ExXHKuHxVEEeNs13RjexSn4Zh68poILsC4FWXTFiJbOAImsjcZIGJPVltkz2GdrJoJMJq1CK3stQRxLpHT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj14LZTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj14LZTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B5C116B1;
	Tue,  2 Jul 2024 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940291;
	bh=NoP3/PO1nQ35zfmG/1hSeiUBQiBMNDGSUO4nQJJCTBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj14LZTqvls3200we1SvrwsVVWRD+LHCuiR9Kc4L7+Erxsv5u9hGX5ZGCfnXjCsJS
	 LGfGQpbVz6cmMKwQ7kfvf9XhUezLDBu9twKiAFhdPMRvnuu0ZOaXOKlldIAS++BuPW
	 zrE/8Ryr8gWyIwLXYg1LtLg9ebj3RAgTWOhGc8kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 109/222] tools/power turbostat: option -n is ambiguous
Date: Tue,  2 Jul 2024 19:02:27 +0200
Message-ID: <20240702170248.132453057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

[ Upstream commit ebb5b260af67c677700cd51be6845c2cab3edfbd ]

In some cases specifying the '-n' command line argument will cause
turbostat to fail.  For instance 'turbostat -n 1' works fine; however,
'turbostat -n 1 -d' will fail.  This is the result of the first call
to getopt_long_only() where "MP" is specified as the optstring.  This can
be easily fixed by changing the optstring from "MP" to "MPn:" to remove
ambiguity between the arguments.

tools/power turbostat: option '-n' is ambiguous; possibilities: '-num_iterations' '-no-msr' '-no-perf'

Fixes: a0e86c90b83c ("tools/power turbostat: Add --no-perf option")

Signed-off-by: David Arcari <darcari@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 98256468e2480..8071a3ef2a2e8 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -7851,7 +7851,7 @@ void cmdline(int argc, char **argv)
 	 * Parse some options early, because they may make other options invalid,
 	 * like adding the MSR counter with --add and at the same time using --no-msr.
 	 */
-	while ((opt = getopt_long_only(argc, argv, "MP", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "MPn:", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'M':
 			no_msr = 1;
-- 
2.43.0



