Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A479C5
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 13:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAF6C433EF
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 13:25:07 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pChHt-00GW5J-MG
	for patches@lists.linux.dev;
	Tue, 03 Jan 2023 13:25:05 +0000
Resent-From: Marc Zyngier <maz@kernel.org>
Resent-To: patches@lists.linux.dev
Resent-Date: Tue, 03 Jan 2023 13:25:05 +0000
Resent-Message-ID: <df7aaa7df653884167a4bc37832f0039@kernel.org>
Received: from dfw.source.kernel.org ([139.178.84.217])
	by disco-boy.misterjones.org with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <SRS0=VLww=5A=arm.com=alexandru.elisei@kernel.org>)
	id 1pCg5H-00GV73-NY
	for maz@misterjones.org;
	Tue, 03 Jan 2023 12:08:02 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 7858161275
	for <maz@misterjones.org>; Tue,  3 Jan 2023 12:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id F1B0FC433EF; Tue,  3 Jan 2023 12:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id B619BC433D2
	for <maz@kernel.org>; Tue,  3 Jan 2023 12:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B619BC433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F5D71516;
	Tue,  3 Jan 2023 04:08:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEE8A3F587;
	Tue,  3 Jan 2023 04:07:51 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Date: Tue,  3 Jan 2023 12:07:36 +0000
Message-Id: <20230103120736.116523-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	disco-boy.misterjones.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,GREYLIST_ISWHITE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.6
Subject: [PATCH] MAINTAINERS: Remove myself as a KVM/arm64 reviewer
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: patches@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Haven't done any meaningful reviews for more than a year, and it doesn't
look like I'll be able to do so in the future. Make it official and remove
myself from the KVM/arm64 "Reviewers" list.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f86d02cb427..813673637500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11356,7 +11356,6 @@ F:	virt/kvm/*
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
-R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Oliver Upton <oliver.upton@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.39.0



