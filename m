Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041894;
	b=k+A3MK27Zf9OzbIUIwZYo4lt+dp26WsigvGpH9lrD81O5CDwfIxisqAqpKems+yfaNjI
	 fQndB5MEIxOTKssK1QAFsDAsw7HkVh0AR9/bLppXhJXqBNDQizYMqJTBgu/+7QRwoa009
	 oed9ybqcVlw77rgGq/yAwJJhU3jrW2kV+TdAwCig0Hr3ht0fpmKvaIJxyf7NsWwIK+Kc6
	 MxlcMayeK4h+cPHoodBnIY730/BmXEFnw6d9fAhCeI+r/EzjQo5d0ymrK5KI10W2myVmw
	 crz8LxomFwwR7lLGedNtGV/aY4EWCUIHpKGas2X1pk8dRouEXEQ7Kh+TuwnSS7uBhSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CtbhKDY6fIMOcoVno4gHZDgZySZDRufs6qRFgVzipgE=;
	b=1H9FPFnN4CE3LFjxH1IzgwQYCf3MzFWLpGUzCas3xPHEWyZ2B7r5PzjzUbE1U3i3B84K
	 fIngKpa8/QL+Z4a/4JVUHEPyjbDL5sz2nkOKUbmYQ90r6p7tMyDA2eE6QGY+2NFaORysz
	 amcKBFQ0X1rHYQkPEje8MuaeIMI7VFMENaelSUyt5E9G53nZu4plDqVdU0Rd8VYdP8PgU
	 5lG+Ci2Xf0nkQeQD0iuk2QBwbq4yoC9TG/WZmAplS99eq7bZaRI66/vJAqerZwT4IRV4c
	 vT3qZohb/bX0/tLaZv59m7gCeqXB7CpDxX1AfElPbytCWoUI0ZIyLO9PGNZK5pubApw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm7vyBJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA68606A325;
	Wed, 18 Nov 2026 22:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lm7vyBJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8067C1F000C4;
	Wed, 18 Nov 2026 22:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041894;
	bh=CtbhKDY6fIMOcoVno4gHZDgZySZDRufs6qRFgVzipgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm7vyBJefpgfLvyX4GUh9qb2Py2bFz6iMpF+tGD9QRVVFp9s9+3uBHqUvePXo7Cy3
	 F0/CoVGVQid6pJeSJ9Ne6FoPV+VS8FIvpnL3/CTRm/HDWIgM+5swhK5UI05dh8LfiC
	 NJonIAiefxLLJljl9XryiOgrPZKTqjfksnN+7lsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2939/3318] ASoC: Intel: avs: Prevent module info underflow
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150448.528450192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 05c2975b4267246219e7aead0467626107e204e9 ]

Typically modules information is first initialized when loading the base
AudioDSP base firmware and then expanded when loadable DSP modules are
requested by platform-components, see avs_component_load_libraries().

While theoretically not possible in a production scenario, there is no
reason to continue the IDAs preparation if an event caused the newly
obtained module information to be smaller or equal than the existing
information.

Fixes: c1a427e8da93 ("ASoC: Intel: avs: Firmware resources management utilities")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/utils.c b/sound/soc/intel/avs/utils.c
index 82416b86662d8..002ecb089f897 100644
--- a/sound/soc/intel/avs/utils.c
+++ b/sound/soc/intel/avs/utils.c
@@ -118,9 +118,11 @@ avs_module_ida_alloc(struct avs_dev *adev, struct avs_mods_info *newinfo, bool p
 	int i;
 
 	if (!purge && oldinfo) {
-		if (oldinfo->count >= newinfo->count)
-			dev_warn(adev->dev, "refreshing %d modules info with %d\n",
+		if (oldinfo->count >= newinfo->count) {
+			dev_warn(adev->dev, "modules info underflow, old: %d, new: %d\n",
 				 oldinfo->count, newinfo->count);
+			return -EPROTO;
+		}
 		tocopy_count = oldinfo->count;
 	}
 
-- 
2.53.0



