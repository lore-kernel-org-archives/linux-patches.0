Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD9142E73;
	Wed,  3 Jul 2024 10:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003352; cv=none; b=U030Z9MH4AEOBrMSQcMjgzM96SvslDcGypeRVDGMR5ypr13vccb2E6FJ6VA/Wj7Nm9tbhXqDvZ07dk66ul/m8+irMIyeNpdJ0L7je7Rvzyt1tltRAHYL4SHA60I3zDY5zM1+UfYgwCwO1jA6+suwuqZnG9wlh+4ne1YCjX6uOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003352; c=relaxed/simple;
	bh=CFeWUrrLuQf24cIAt8wtjuVD5Yx/CeSyjqv6lxFmYmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULFbNCADq7Kbw92S49yYKm1oWbpFI5mHylUx/J6Bibgj7Zra5BTBAoxDWnvl8yM7719kwVzwMI5gQFYRYT48nNgFhMjYvzksDx60O6M1CN081VD43krtr4GG0OVFUvbp3RBpwoe03ofs91m6wHDWlyUiYYYV4I730C8RRFMLpns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5D5ATAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5D5ATAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E34C2BD10;
	Wed,  3 Jul 2024 10:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003352;
	bh=CFeWUrrLuQf24cIAt8wtjuVD5Yx/CeSyjqv6lxFmYmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5D5ATAcFAS9wgeYH2v4CyZM7j7LXgd6VbINgwpqL8g+G9MfOgL8eTcVgYLzhABKU
	 QP6Pg4/W5q6ZrNMpei0gjt7VyvCgu2pRiH8FEzaUV9uQ3lYp36Qn7bj0fFOGKPphf9
	 Vaef4+boOMZj2ia8590l5AVmFV5WgESxQ6moChCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/139] wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64
Date: Wed,  3 Jul 2024 12:38:20 +0200
Message-ID: <20240703102830.564905798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4a7aace2899711592327463c1a29ffee44fcc66e ]

We don't actually support >64 even for HE devices, so revert
back to 64. This fixes an issue where the session is refused
because the queue is configured differently from the actual
session later.

Fixes: 514c30696fbc ("iwlwifi: add support for IEEE802.11ax")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.52f7b4cf83aa.If47e43adddf7fe250ed7f5571fbb35d8221c7c47@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index d0f47899f2849..f76f708ea98c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -144,13 +144,8 @@ enum {
 
 #define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(63)
-/*
- * FIXME - various places in firmware API still use u8,
- * e.g. LQ command and SCD config command.
- * This should be 256 instead.
- */
-#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_DEF	(255)
-#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_MAX	(255)
+#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_DEF	(64)
+#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_MAX	(64)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
 
 #define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
-- 
2.43.0



