Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A532117E90E;
	Mon, 27 May 2024 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836842; cv=none; b=l5xXia8x2BboXclwdEllQNDRCUKD5qxS2ftFvJbH4xmDLLMAIGBblERwxJSV0XKiEfAhNnU1J1+ERRL0jGvBEFPkr6mrZRAhopvh079DiRNPaJ7+qtGX2ubz51Nd39GaIMWEdFL1D1LMJPWtKljcozimUl3yrZY2n4iGZyOYTfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836842; c=relaxed/simple;
	bh=2UwjFP8DTXA8N8rHFAedp9NDe4NAJo5G7C0gc5PiUsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dE6k8bBHEwDy5g5O54NLRBtTYZzwRiuq0zgmSwE7+cGA6iN6NbR4trNvv2CjmDuNd/3SD8OMKNixLTNmU7L5ifjvrODAmFN3a9b6QcI8ZSbrIFPqB9YfV9KpW5ixaixcAdcdGac8LrEX6fjBh0RGtzv8mv8owk0TlykWKvSFydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvybEvfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvybEvfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384C1C2BBFC;
	Mon, 27 May 2024 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836842;
	bh=2UwjFP8DTXA8N8rHFAedp9NDe4NAJo5G7C0gc5PiUsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvybEvfS0Fd5yZhP4Ob+FPcj4YmO78jL329+sHNYBKWlStStLy9Wxhl3DWV+XVXoL
	 aimsWSHbk93pLgl9jPLWyPTJrEif5Obp2BRKLxkBZbNkmeIvmMlKleDFhKftAoNSZx
	 Yl7rqJsbl8KtUJP8pQBURz4khZTQ64Gb/cI91RrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 209/427] selftests: power_supply: Make it POSIX-compliant
Date: Mon, 27 May 2024 20:54:16 +0200
Message-ID: <20240527185621.873656179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 5b1c8b1e56ff8b5e9c1a09606af3627bb55933cf ]

There is one use of bash specific syntax in the script. Change it to the
equivalent POSIX syntax. This doesn't change functionality and allows
the test to be run on shells other than bash.

Reported-by: Mike Looijmans <mike.looijmans@topic.nl>
Closes: https://lore.kernel.org/all/efae4037-c22a-40be-8ba9-7c1c12ece042@topic.nl/
Fixes: 4a679c5afca0 ("selftests: Add test to verify power supply properties")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/power_supply/test_power_supply_properties.sh      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/power_supply/test_power_supply_properties.sh b/tools/testing/selftests/power_supply/test_power_supply_properties.sh
index df272dfe1d2a9..a66b1313ed882 100755
--- a/tools/testing/selftests/power_supply/test_power_supply_properties.sh
+++ b/tools/testing/selftests/power_supply/test_power_supply_properties.sh
@@ -23,7 +23,7 @@ count_tests() {
 	total_tests=0
 
 	for i in $SUPPLIES; do
-		total_tests=$(("$total_tests" + "$NUM_TESTS"))
+		total_tests=$((total_tests + NUM_TESTS))
 	done
 
 	echo "$total_tests"
-- 
2.43.0



