Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50678B61;
	Tue, 27 Feb 2024 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043326; cv=none; b=VGtRpH8h0xSEmAscsh+8lAPWEf4IXSFMS/9F1W01IK+DMNhkbtZ4jgOC/q2sc6abKBjLJjPhn7HPNmQPCZZASQ11KyvuN7PxRCpSiFRYtAf+0eLhG5uogC4rM0QvmjEOTLqxpxr2eiGjtl3J/9TuAaPNMho/BIbwlhgDjLB06P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043326; c=relaxed/simple;
	bh=BVlo39vXhjaS0NZL2nesD6Q/NHXV0KBES2ZS2uIFNAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqMg9YzlGFOLLYyY4Qgep5p+NsTPA1Fie/aVMjzloM5FV/loPPYEAyV6vA1UJz5nUkxxIkUHOr+wmB8KmmwjQYyzAtHIHLoQ1FIp2E3hMo95UXrLq0Pd3ldxcueTqX8khNxQeDCRdBKjPPq+VVZRME7dXqRSJe3p6uy2+h+LDE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRm3ptog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRm3ptog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3639EC433C7;
	Tue, 27 Feb 2024 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043326;
	bh=BVlo39vXhjaS0NZL2nesD6Q/NHXV0KBES2ZS2uIFNAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRm3ptogNbtTE2vxy8+Zd8AVTHJdCArq226W9xBwAEfS7DzYrbFEu1KsFwWty5nNO
	 8UnHsJTYmBjDKQ0FLYGVV4viMYcI/tCHsKosn6JoPvGSmTEJ9TKgymlmWZyQPTQ9Zn
	 LdbGsB12hsT6/4QarXdWayhzzs7c0a6hBdfr364g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/195] wifi: mac80211: set station RX-NSS on reconfig
Date: Tue, 27 Feb 2024 14:25:27 +0100
Message-ID: <20240227131612.682434074@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit dd6c064cfc3fc18d871107c6f5db8837e88572e4 ]

When a station is added/reconfigured by userspace, e.g. a TDLS
peer or a SoftAP client STA, rx_nss is currently not always set,
so that it might be left zero. Set it up properly.

Link: https://msgid.link/20240129155354.98f148a3d654.I193a02155f557ea54dc9d0232da66cf96734119a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2c4866080bd7..6cf0b77839d1d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1775,6 +1775,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					      sband->band);
 	}
 
+	ieee80211_sta_set_rx_nss(link_sta);
+
 	return ret;
 }
 
-- 
2.43.0



