Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E39C24BC19;
	Thu, 13 Feb 2025 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457421; cv=none; b=Cr3i7Xt9wJLbS3YdL2Hnzn+jDeHSRnde7mtyn2bke+rVG4amImC2ZWiRBxMAonhNIMbsbsw/fZAqg64V2YDpmu7vp54PE66obYhL2S/PdLPkPELw5QCuVyK6lSzGg7oNsImkjuoz7OzG/HAkJKujoWhDVeB+qHKrq3LRvRB6Lgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457421; c=relaxed/simple;
	bh=W/Gz/WoRelX8KI3S6deyO9xWTRCgkohMOESW+YtUBss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc6X3/KsYG5sUzoZNjiN0ffubJf+A+7RzmpH9sEH+D6ByiFrmK5LELWsV6e7jzaruBQJUI6vYGejh6Czdhy2gE24WPvjbAIloZKUr+bFm+Vx5SUV0NkRk+pPBPi9iWJ/IIM09snLepBecobBa1JhRqO8+iTwFfZ/rAoOlXutHX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9RHAVOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9RHAVOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E361C4CED1;
	Thu, 13 Feb 2025 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457421;
	bh=W/Gz/WoRelX8KI3S6deyO9xWTRCgkohMOESW+YtUBss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9RHAVOufhViQkc//H6IkGhvWZ7yeK4H3fWT+WEhV2dyzyz8MIyvuZoCdH+56H0nF
	 q10uDlDVS43Q9AhtLClXD+EsTWxB4jXQ05UCxKYKpKNL1c2Q+VnepjSmAuizRfN09n
	 L0Q9wqR/E8F0BfCYYr63vcBF+stuLwVcyL1mR/ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/422] nvme: make nvme_tls_attrs_group static
Date: Thu, 13 Feb 2025 15:24:15 +0100
Message-ID: <20250213142440.648267454@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2d1a2dab95cdc6f2e0c6af3c0514b0bea94af482 ]

To suppress the compiler "warning: symbol 'nvme_tls_attrs_group' was not
declared. Should it be static?"

Fixes: 1e48b34c9bc79a ("nvme: split off TLS sysfs attributes into a separate group")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index b68a9e5f1ea39..3a41b9ab0f13c 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -792,7 +792,7 @@ static umode_t nvme_tls_attrs_are_visible(struct kobject *kobj,
 	return a->mode;
 }
 
-const struct attribute_group nvme_tls_attrs_group = {
+static const struct attribute_group nvme_tls_attrs_group = {
 	.attrs		= nvme_tls_attrs,
 	.is_visible	= nvme_tls_attrs_are_visible,
 };
-- 
2.39.5



