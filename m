Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAA47ACF9;
	Sat, 12 Sep 2026 12:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214975; cv=none; b=HTQ/BSyjxYecu3GzQpj2fgTpVYWCpbPXI4Q4VTyCwfwO77qka6X6T6cAWlvWvggSkkb84puCoiZJgZe9avG5P9daQLrlauGuTExEEdVKNS9nl/eP61wWM+/C+/9tymeo/77rj2mrcSSEo9Q3pudU/0651Op7VyxoVlVAPQOlguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214975; c=relaxed/simple;
	bh=aByS5lwSl3ubyn8IUDzOsIwdlKpQ0JTcn6Su8z9OCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgAUgW5pQdau2m254O5Ll9mb/FHnZ0fOeN9my6wu6p1/kzltrbaXp2xc5kdaQ/0gi7G2pxsGTEMuyWnRNF9crCs1EdZIvMjT/gIxIddxmBBHG4dPt0DKYvnZ4xyBKWG5C2ivHwzk0vYIe7WmwfyLj/KBkYAAcoJCAPKsn7x8gLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOS/FeR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOS/FeR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31F51F000FF;
	Sat, 12 Sep 2026 12:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214972;
	bh=XG03qtPUMFUAcMT6If7Kq9we4UOdlDwwBHF4LpAPyLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOS/FeR2YaKGbxv7KfKRbkc/yj8Xzi9ohTxyl1/LvjKpO0arZvGYFCDJ/L7Z4rTl9
	 TfCF5QWOxjts6dcr9juHqgMvtgilV8RYsaMLfYcb0LN9D2p20X3NnEnfl6HcqG4bbY
	 Z5R3S3BxYgfWNTKdEucP+sxoKg7T7vgHX5AKCWMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0437/1376] selftests: timers: leap-a-day: Fix -w option and update usage comment
Date: Sat, 12 Sep 2026 08:47:43 +0200
Message-ID: <20260912065617.274485500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit b4b66151a71445f3a71574136ddc82968c7b175e ]

Commit 98b74e1f3104 ("kselftests: timers: leap-a-day: Change default
arguments to help test runs") replaced the -s option with -w and made
"wait for the leap second" the non-default behaviour, but it only
updated the switch/case handling. Two things were left inconsistent:

  - The getopt() option string still lists 's' instead of 'w', so
    passing -w is rejected as an invalid option and the new behaviour
    cannot be selected at all.

  - The file header comment still documents the removed -s option and
    an outdated default for -i.

Fix the getopt() string to accept 'w' (matching the existing case 'w':
handler) and update the header comment to describe -w, -t and the
current -i default.

Fixes: 98b74e1f3104 ("kselftests: timers: leap-a-day: Change default arguments to help test runs")
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260702093915.2652638-1-yijiangshan@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/leap-a-day.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/timers/leap-a-day.c b/tools/testing/selftests/timers/leap-a-day.c
index 986abbdb15217..eb99683e5ced1 100644
--- a/tools/testing/selftests/timers/leap-a-day.c
+++ b/tools/testing/selftests/timers/leap-a-day.c
@@ -9,16 +9,19 @@
  *  kernel's leap-second behavior, as well as how well applications
  *  handle the leap-second discontinuity.
  *
- *  Usage: leap-a-day [-s] [-i <num>]
+ *  Usage: leap-a-day [-w] [-i <num>] [-t]
  *
  *  Options:
- *	-s:	Each iteration, set the date to 10 seconds before midnight GMT.
- *		This speeds up the number of leapsecond transitions tested,
- *		but because it calls settimeofday frequently, advancing the
- *		time by 24 hours every ~16 seconds, it may cause application
- *		disruption.
+ *	-w:	Only set the leap-second flag and wait for the leap second
+ *		each iteration, instead of advancing the time. By default the
+ *		date is set to 10 seconds before midnight GMT, which speeds up
+ *		the number of leapsecond transitions tested, but because it
+ *		calls settimeofday frequently, advancing the time by 24 hours
+ *		every ~16 seconds, it may cause application disruption.
  *
- *	-i:	Number of iterations to run (default: infinite)
+ *	-i:	Number of iterations to run (-1 = infinite, default: 10)
+ *
+ *	-t:	Print TAI time.
  *
  *  Other notes: Disabling NTP prior to running this is advised, as the two
  *		 may conflict in their commands to the kernel.
@@ -186,7 +189,7 @@ int main(int argc, char **argv)
 	int opt;
 
 	/* Process arguments */
-	while ((opt = getopt(argc, argv, "sti:")) != -1) {
+	while ((opt = getopt(argc, argv, "wti:")) != -1) {
 		switch (opt) {
 		case 'w':
 			printf("Only setting leap-flag, not changing time. It could take up to a day for leap to trigger.\n");
-- 
2.53.0



