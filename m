Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ADE238C19;
	Mon,  2 Jun 2025 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872985; cv=none; b=G1auFEArawx/c9p66qPTWtYUtFuB6EK9uJN1C0p4MfB9yUg4Kjps6XkDQnBy7MXd0NBe9tiLv5GrQwEMKW0PHRLQmCd86lpxca10r/pjuKPPFivjdMy9Xf2bRfewLF0t7pSAsY6EIJpFxHlbtV93Fsf2JictNj4re1j2WCkgUjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872985; c=relaxed/simple;
	bh=pSltus4KGi6fgVWySzAUtQ5NbWDXuN/OciCJu/AtC5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vkod4G/ZBlgZBRkN7OtVhQdjs1yO75BlsN2X9ZTQEYdueB2j3l7ec+4h8pdTNGtHyhNt7yUc1c5+UexNQc7gAD6s6+gugo2VeF34GZOuPdrnyzXAjil7DKmRNailYqmGyrNQQXwtaOQxhz5QHcv4O8UtNLGGLGtZVDgtdbNkFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh37wnP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh37wnP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A535C4CEF0;
	Mon,  2 Jun 2025 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872985;
	bh=pSltus4KGi6fgVWySzAUtQ5NbWDXuN/OciCJu/AtC5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh37wnP7RjQAPHp7ODwiRRco35dP95MVmuh77D52VcphwiwiLC9LYXw8J9gXOoRcN
	 nPOjtmMDdAlMPbCscQ0mnrwuz7x/3Nd/z+Cqn/el7rSmGkY1K9nrx5M2Y0jMITqiA2
	 yV83xd/9gk3aK3bPcbMtj2GnaIJGP6WbcjnUHZJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 30/55] perf/arm-cmn: Fix REQ2/SNP2 mixup
Date: Mon,  2 Jun 2025 15:47:47 +0200
Message-ID: <20250602134239.464829653@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 11b0f576e0cbde6a12258f2af6753b17b8df342b upstream.

Somehow the encodings for REQ2/SNP2 channels in XP events
got mixed up... Unmix them.

CC: stable@vger.kernel.org
Fixes: 23760a014417 ("perf/arm-cmn: Add CMN-700 support")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/087023e9737ac93d7ec7a841da904758c254cb01.1746717400.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -727,8 +727,8 @@ static umode_t arm_cmn_event_attr_is_vis
 
 		if ((chan == 5 && cmn->rsp_vc_num < 2) ||
 		    (chan == 6 && cmn->dat_vc_num < 2) ||
-		    (chan == 7 && cmn->snp_vc_num < 2) ||
-		    (chan == 8 && cmn->req_vc_num < 2))
+		    (chan == 7 && cmn->req_vc_num < 2) ||
+		    (chan == 8 && cmn->snp_vc_num < 2))
 			return 0;
 	}
 
@@ -884,8 +884,8 @@ static umode_t arm_cmn_event_attr_is_vis
 	_CMN_EVENT_XP(pub_##_name, (_event) | (4 << 5)),	\
 	_CMN_EVENT_XP(rsp2_##_name, (_event) | (5 << 5)),	\
 	_CMN_EVENT_XP(dat2_##_name, (_event) | (6 << 5)),	\
-	_CMN_EVENT_XP(snp2_##_name, (_event) | (7 << 5)),	\
-	_CMN_EVENT_XP(req2_##_name, (_event) | (8 << 5))
+	_CMN_EVENT_XP(req2_##_name, (_event) | (7 << 5)),	\
+	_CMN_EVENT_XP(snp2_##_name, (_event) | (8 << 5))
 
 #define CMN_EVENT_XP_DAT(_name, _event)				\
 	_CMN_EVENT_XP_PORT(dat_##_name, (_event) | (3 << 5)),	\


