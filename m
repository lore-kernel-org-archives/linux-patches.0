Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200FE1EA76;
	Tue, 30 May 2023 18:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D4EC433D2;
	Tue, 30 May 2023 18:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685471109;
	bh=5Z/L4aaUTHJKLlI+7HjDSf1F8Ul0/QVqmqZRqapzsSE=;
	h=From:Subject:Date:To:Cc:From;
	b=aTdwD6M+jTY6IjHIJA3boSGFWL2+d7dVsH18stkyEgeBvj+YIMzS7AdTXQ0MSUp0w
	 C/Q6ep83yLJfeaLiJYq43yMvt0ki9dQSlD2hbKMEjlcKIn1d/Exailp2FrNRMvRYL/
	 D4yicdLH3EkCUxTopUDe6nlQZnap2sMB4JNTFy1T0ebSwiJfBG267VHwjIjUCbOmGS
	 8yzK0TWuHBBtbZADFL9XGN3iCfKYuHLl5Iy65GeWf0eveNWmlqM0ON8mDsVE8gFcQP
	 ZHzGnpjX6Vs2+ARxnSGC44mQth8/vEc1L2kPsGduAgv+8GPe2OeuHH7CF90Hra4dZ3
	 5HaPNPhmdkqXw==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] drm/i915/gt: Fix recent kCFI violations
Date: Tue, 30 May 2023 11:24:37 -0700
Message-Id: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGU/dmQC/x2OUQqDMBBEryL57oImTcFepZSybldd0BiSrW0R7
 97Yz8cw82YzmZNwNtdqM4lXybKEAs2pMjRiGBjkWdjY2rrauxqkbTwMCoQ08mPilSd4S6Bljqj
 STQz9K5CWGYiLBOUE+o2cIWsSUnAWPV28PbfoTbF0mBm6hIHGwzNjLpUjiIl7+fyv3e77/gOl7
 9YnqgAAAA==
To: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, 
 rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com
Cc: ndesaulniers@google.com, trix@redhat.com, andi.shyti@linux.intel.com, 
 fei.yang@intel.com, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1064; i=nathan@kernel.org;
 h=from:subject:message-id; bh=5Z/L4aaUTHJKLlI+7HjDSf1F8Ul0/QVqmqZRqapzsSE=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCll9i1ZsbmlOizaVwK3GyY8sX/Hby9/3HrTEouvl60y2
 rWOyrzsKGVhEONgkBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABPRsWL4p5oSt/HEtPJzi/3E
 bnGe2ajbGuCfYSt6wNNXcNnFP40z5zP8z/kS/bqvzOFORcTHLzk3H2WfP5542u2C9Ix5GvGzl9V
 dZAcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series fixes a few clang kernel Control Flow Integrity (kCFI)
violations that appear after commit 9275277d5324 ("drm/i915: use
pat_index instead of cache_level"). They were found between run time
testing on real hardware and compile time testing with
-Wincompatible-function-pointer-types-strict (which is not yet enabled
for the kernel but I build with it locally to catch new instances).

If there are any problems or questions, please let me know.

---
Nathan Chancellor (2):
      drm/i915/gt: Fix second parameter type of pre-gen8 pte_encode callbacks
      drm/i915/gt: Fix parameter in gmch_ggtt_insert_{entries,page}()

 drivers/gpu/drm/i915/gt/intel_ggtt.c      | 26 +++++++++++++-------------
 drivers/gpu/drm/i915/gt/intel_ggtt_gmch.c |  8 ++++----
 2 files changed, 17 insertions(+), 17 deletions(-)
---
base-commit: 08264f85c5c05ecc38d409c84d48cfb00ccd3bc4
change-id: 20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-32a5c65249a5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

