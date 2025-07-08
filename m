Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD142E659;
	Tue,  8 Jul 2025 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992033; cv=none; b=P6F3AWc/n6gsyzDbzh/W0QZs42dXOEO0Pt33j3EpR8GNULZxwcMN3ltbtIIT7+IL7iNUvfFQZJ7I97+HzgqOm9ZU7e/nJCZQoRtTTMX9Xg8ofWGdvpHPU7zGlcL7/B7ntQo2yV5H8ui5dFReZ0bj03+ryo1lhAzxC2MvgcTRF/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992033; c=relaxed/simple;
	bh=LF0Awvfm+GPsf6flEAS8VGPcLOAhMLhisu5iOCd6itw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sop/bOkmBsUxdhWfLx4Ya3zRvszbbgH42+yZyGIT2mmGYBUSFp8dlbsYP3lotSclcT8MxPIJUWvoz8rhrz7mLgBX3K3sfWlLJC2I6CKMOnrrgGgbeJqQyouJmVcm+ybB8uGU1ixSPA6hV410eqSNZFwROEGgQakZyfvajvbNpWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVL1G80r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVL1G80r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FEEC4CEED;
	Tue,  8 Jul 2025 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992032;
	bh=LF0Awvfm+GPsf6flEAS8VGPcLOAhMLhisu5iOCd6itw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVL1G80rWpkXiVpTKn5ZozW+5iLl0l9xMpvENYwCzWEtipZykybmh2IN6X514tXRF
	 Ck0eVntN54wvroCVZ8FZQ8TXAiXpzk3fJDruHBlTp+stG4xNHOl8JPkWPpSsfsrEXM
	 J6C/FqZHUyOwJsL45tQicwx2G6d8lDGxyAMI5Oeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/81] lib: test_objagg: Set error message in check_expect_hints_stats()
Date: Tue,  8 Jul 2025 18:23:29 +0200
Message-ID: <20250708162226.154288237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e6ed134a4ef592fe1fd0cafac9683813b3c8f3e8 ]

Smatch complains that the error message isn't set in the caller:

    lib/test_objagg.c:923 test_hints_case2()
    error: uninitialized symbol 'errmsg'.

This static checker warning only showed up after a recent refactoring
but the bug dates back to when the code was originally added.  This
likely doesn't affect anything in real life.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202506281403.DsuyHFTZ-lkp@intel.com/
Fixes: 0a020d416d0a ("lib: introduce initial implementation of object aggregation manager")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8548f423-2e3b-4bb7-b816-5041de2762aa@sabinyo.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_objagg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index c0c957c506354..c0f7bb53db8d5 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -899,8 +899,10 @@ static int check_expect_hints_stats(struct objagg_hints *objagg_hints,
 	int err;
 
 	stats = objagg_hints_stats_get(objagg_hints);
-	if (IS_ERR(stats))
+	if (IS_ERR(stats)) {
+		*errmsg = "objagg_hints_stats_get() failed.";
 		return PTR_ERR(stats);
+	}
 	err = __check_expect_stats(stats, expect_stats, errmsg);
 	objagg_stats_put(stats);
 	return err;
-- 
2.39.5



