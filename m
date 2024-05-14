Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDEE139CE4;
	Tue, 14 May 2024 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683007; cv=none; b=k8V1UXEbJjLi38cyRvZ9vjLvT7oC+JjFc29XnwlfCNZ8GhC0ehos97qVh5gIyQVfuYm/kaaetQIIY/Q0jE+EDxKf7DDJ6cyZ2gmvCs14DALGKVuZ8gpJCIsTvBUeAuT4lKuKVLZn52zHOA5v51t8OlZxvKalAbEdj8ZAXfHuY6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683007; c=relaxed/simple;
	bh=iUKVut38R68KkmSYslHYgLZu5TEKlXEmbDB8V8kFt38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+JocYM+MYUrfxWsykektVnsgmSszohNXpu2IxHonYrK8SVNiCBzVeWo6f0wwyRKXGZltxBJCA7QnGymlcGo4NgjQ8AHV+bzOlK624tHovOZl6svO2dSNKowqwlIPTxEnOe/4AWCc/lhGMbM6iVAmdl8VDArt6fBs5tA52q0eqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1DUTb0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1DUTb0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDD1C2BD10;
	Tue, 14 May 2024 10:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683007;
	bh=iUKVut38R68KkmSYslHYgLZu5TEKlXEmbDB8V8kFt38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1DUTb0yIOR5OMF56bUPOPKoIiNVSJ+KZJA4ShvVmUgihct4qP4xGfo9knNfxdH1+
	 DUhPJRxKKPAa3C7SaPt64G4UQrTdY4tPYNRBDkf4YGMZBdLqFeTZcvXiQjNF/or2om
	 /w3fRIiKX6ybtvPoe95p5Xlvo9UYtxVFgaIkfmL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wachowski, Karol" <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Wachowski
Subject: [PATCH 6.8 151/336] accel/ivpu: Improve clarity of MMU error messages
Date: Tue, 14 May 2024 12:15:55 +0200
Message-ID: <20240514101044.303631447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wachowski, Karol <karol.wachowski@intel.com>

[ Upstream commit 3556f922612caf4c9b97cf7337626f8342b3dea3 ]

This patch improves readability and clarity of MMU error messages.
Previously, the error strings were somewhat confusing and could lead to
ambiguous interpretations, making it difficult to diagnose issues.

Signed-off-by: Wachowski, Karol <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-6-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_mmu.c b/drivers/accel/ivpu/ivpu_mmu.c
index 91bd640655ab3..2e46b322c4505 100644
--- a/drivers/accel/ivpu/ivpu_mmu.c
+++ b/drivers/accel/ivpu/ivpu_mmu.c
@@ -278,7 +278,7 @@ static const char *ivpu_mmu_event_to_str(u32 cmd)
 	case IVPU_MMU_EVT_F_VMS_FETCH:
 		return "Fetch of VMS caused external abort";
 	default:
-		return "Unknown CMDQ command";
+		return "Unknown event";
 	}
 }
 
@@ -286,15 +286,15 @@ static const char *ivpu_mmu_cmdq_err_to_str(u32 err)
 {
 	switch (err) {
 	case IVPU_MMU_CERROR_NONE:
-		return "No CMDQ Error";
+		return "No error";
 	case IVPU_MMU_CERROR_ILL:
 		return "Illegal command";
 	case IVPU_MMU_CERROR_ABT:
-		return "External abort on CMDQ read";
+		return "External abort on command queue read";
 	case IVPU_MMU_CERROR_ATC_INV_SYNC:
 		return "Sync failed to complete ATS invalidation";
 	default:
-		return "Unknown CMDQ Error";
+		return "Unknown error";
 	}
 }
 
-- 
2.43.0



