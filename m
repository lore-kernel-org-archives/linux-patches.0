Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967A439A805;
	Thu, 15 Jan 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496762; cv=none; b=L8ZwFO0pCeEjTVuAe+MSO1vqv0DmVk5uYH41dxk8AElaLwTvjo/q97Rp59sLvLsRANtzKn7TGSj0f+J/AgFfL6YkdnAeeumP6Qa8/jsdgepQFXQ/NWe2gow8dcw0dtZsHOiSRvK/zKo6ctQ9SSwOmVic2mMgOCOnB2S2F+WBcvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496762; c=relaxed/simple;
	bh=CXhE8SYqzcJNWWLP1uEqoaOkpiezY8U6tCC1wSsL/iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNHoCkgV6XWv/5GY9uAjdsWcP7FbD2+7vdsIQTapPsCQPuFi/q+7jcbxumpM9xXo9bIrolYsqSEFGEeJ2uWqXiKwPxI9iN1RuwB8Ea6FgBJt3hBRVhnffMqlzrsWtzHQTvHKJQM+xAc0q963Ft3wsxazePakXm4LHGsoy4+HIQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4gfnp5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4gfnp5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191D2C16AAE;
	Thu, 15 Jan 2026 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496762;
	bh=CXhE8SYqzcJNWWLP1uEqoaOkpiezY8U6tCC1wSsL/iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4gfnp5TaZnWIK3Pzc8xinziCtv/qQpo1Ui4CXWwJDreryAOxxnelVL9WAQBpGR03
	 IzZgRENEso2aRjQ4EnalaJ5gi5ZmTg3oxfIl7lkI/wP8jtsBQkDkjMxmc9kGuoOeHR
	 Ep9XujoVDUZfndp8VlNOCsVhOiJ/T81/QCqeZWVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Kocoloski <brian.kocoloski@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/119] drm/amdkfd: Fix improper NULL termination of queue restore SMI event string
Date: Thu, 15 Jan 2026 17:48:44 +0100
Message-ID: <20260115164155.885984941@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Brian Kocoloski <brian.kocoloski@amd.com>

[ Upstream commit 969faea4e9d01787c58bab4d945f7ad82dad222d ]

Pass character "0" rather than NULL terminator to properly format
queue restoration SMI events. Currently, the NULL terminator precedes
the newline character that is intended to delineate separate events
in the SMI event buffer, which can break userspace parsers.

Signed-off-by: Brian Kocoloski <brian.kocoloski@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6e7143e5e6e21f9d5572e0390f7089e6d53edf3c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index de8b9abf7afcf..592953fe9afc2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -312,7 +312,7 @@ void kfd_smi_event_queue_restore(struct kfd_node *node, pid_t pid)
 {
 	kfd_smi_event_add(pid, node, KFD_SMI_EVENT_QUEUE_RESTORE,
 			  KFD_EVENT_FMT_QUEUE_RESTORE(ktime_get_boottime_ns(), pid,
-			  node->id, 0));
+			  node->id, '0'));
 }
 
 void kfd_smi_event_queue_restore_rescheduled(struct mm_struct *mm)
-- 
2.51.0



