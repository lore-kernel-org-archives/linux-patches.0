Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4E9370D43;
	Wed, 20 May 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299325; cv=none; b=qRROBV594ifgV2OOe32MaM09/zRi/jy5bGqM4yh8lVCXY3/Y2Kpjb2X/G9qlqVoUT0s+j67+YqvFe9tAdxefGHSfcr1crCenqHxDbbaK+xzvWIaNSdou2WFTizK0QGk886eGktAFv56RohSRWJ2fhZEoPOicZE9N6DO7p1pnK0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299325; c=relaxed/simple;
	bh=3l+q8xTDIDjfl6eSc4B/PRHZWt2E7JYnU9eHFRQbv8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8+IUTsJY3/nYSQPQLlv1Iitm21SnbAvA0BCbS3PrOzaolmXd8bSyVLLWR1u2D0dqAekea91pB3kMXpOVWXONv/1GPN/cYI2vEbx62OwhI2mvEqMg98Aq2p+xDLdeE/xW0Sk+8f+Qufg6mBKuQ5JKqBZACZIZM7/9lfPDHXsxPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmCazfHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmCazfHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C496D1F000E9;
	Wed, 20 May 2026 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299324;
	bh=d2bBBlPd1r0p88De0yDOBAMLfGTTvgQ8WeneZSLwklM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmCazfHZSE58sogP7QfRXvvYTilaJQfyk9Sl4bwFoF0fXqA3mjHxnP8B8z4BUPAnO
	 GeyUx5pAnxHmQlg4AAfx8C6NkVDYF3t+DXmD4keKeJXezO0OMIq5hnAARRQgd6/ZxR
	 qAg6RTiv/mzVlOU32v+2pQgI4MAFZprZQucmCJ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 729/957] tools/power turbostat: Fix and document --header_iterations
Date: Wed, 20 May 2026 18:20:12 +0200
Message-ID: <20260520162150.363568252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 96718ad296af4a6d984b3a09276b165ab6a3b0c8 ]

The "header_iterations" option is commonly used to de-clutter
the screen of redundant header label rows in an interactive session:
Eg. every 10 rows:

$ sudo turbostat --header_iterations 10 -S -q -i 1

But --header_iterations was missing from turbostat.8

Also turbostat help advertised the "-N" short option
that did not actually work:

$ turbostat --help
  -N, --header_iterations num
		print header every num iterations

Repair "-N"
Document "--header_iterations" on turbostat.8

Signed-off-by: Len Brown <len.brown@intel.com>
Stable-dep-of: ce012c966b51 ("tools/power turbostat: Fix unrecognized option '-P'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 |  4 +++-
 tools/power/x86/turbostat/turbostat.c | 20 +++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 6c9428f98cd2b..3e0487cd6451e 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -111,12 +111,14 @@ The column name "all" can be used to enable all disabled-by-default built-in cou
 .PP
 \fB--no-perf\fP Disable all the uses of the perf API.
 .PP
-\fB--force\fPForce turbostat to run on an unsupported platform (minimal defaults).
+\fB--force\fP Force turbostat to run on an unsupported platform (minimal defaults).
 .PP
 \fB--interval seconds\fP overrides the default 5.0 second measurement interval.
 .PP
 \fB--num_iterations num\fP number of the measurement iterations.
 .PP
+\fB--header_iterations num\fP print header every num iterations.
+.PP
 \fB--out output_file\fP turbostat output is written to the specified output_file.
 The file is truncated if it already exists, and it is created if it does not exist.
 .PP
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 29441e3c711d9..ec4b7ff8810b1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -11040,7 +11040,7 @@ void cmdline(int argc, char **argv)
 	 * Parse some options early, because they may make other options invalid,
 	 * like adding the MSR counter with --add and at the same time using --no-msr.
 	 */
-	while ((opt = getopt_long_only(argc, argv, "+MPn:", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "+:MP", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'M':
 			no_msr = 1;
@@ -11054,7 +11054,7 @@ void cmdline(int argc, char **argv)
 	}
 	optind = 0;
 
-	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:o:qMST:v", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:N:o:qMST:v", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'a':
 			parse_add_command(optarg);
@@ -11097,7 +11097,6 @@ void cmdline(int argc, char **argv)
 			}
 			break;
 		case 'h':
-		default:
 			help();
 			exit(1);
 		case 'i':
@@ -11136,19 +11135,15 @@ void cmdline(int argc, char **argv)
 			num_iterations = strtoul(optarg, NULL, 0);
 			errno = 0;
 
-			if (errno || num_iterations == 0) {
-				fprintf(outf, "invalid iteration count: %s\n", optarg);
-				exit(2);
-			}
+			if (errno || num_iterations == 0)
+				errx(-1, "invalid iteration count: %s", optarg);
 			break;
 		case 'N':
 			header_iterations = strtoul(optarg, NULL, 0);
 			errno = 0;
 
-			if (errno || header_iterations == 0) {
-				fprintf(outf, "invalid header iteration count: %s\n", optarg);
-				exit(2);
-			}
+			if (errno || header_iterations == 0)
+				errx(-1, "invalid header iteration count: %s", optarg);
 			break;
 		case 's':
 			/*
@@ -11171,6 +11166,9 @@ void cmdline(int argc, char **argv)
 			print_version();
 			exit(0);
 			break;
+		default:
+			help();
+			exit(1);
 		}
 	}
 }
-- 
2.53.0



