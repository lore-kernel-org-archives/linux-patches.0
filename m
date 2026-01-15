Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0EE280035;
	Thu, 15 Jan 2026 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496378; cv=none; b=T8QjdRnudk/AZsrVrsE5hcMPCTaw/WDmD70U47egKkO1g+QyQ4WD3hOWpV/r8ACO+GDIeVv0HwM210wFYUQelAFIXSU4Z4jsQOpQUuOYJ6Tl1eQq3wTcpafu6khbRHTCM8ILvZU9eo8ERf3C/4zONZ2xCWNSJ1FMcLaqSykhGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496378; c=relaxed/simple;
	bh=KietZ+Qwk9YetnZI/Jh4zUu/VcASanL5Zbz5dHYL5Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM4442YZ6hcFGJzpXgHjBq46krnPrnTpu0xcMSseZKC9wiE2SaS9OwETVna/w0wHjFxI6BLNiwfEqFfYqTDYR4h1ZLHGBr8tBrS1Uv+JeYaW2nMkbbnOd5ri0EtuoMNdpTyMVBHO6S98LsRD6RlNvjY6EPlwyuAocJAg9++urko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZyTcR9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZyTcR9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E5BC116D0;
	Thu, 15 Jan 2026 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496378;
	bh=KietZ+Qwk9YetnZI/Jh4zUu/VcASanL5Zbz5dHYL5Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZyTcR9dkGl9Gf0QRtOctXCLylCEgQ1L1hGmNEtl9HHZ9r02zMauEqjoBWyoEJOJO
	 01Hl+EtFqkFXlqxTXfa3duX0SUvjlXdg4thAKkwNbBt4LpDJc2S66nrOPOwaUWe/2M
	 YWTkuyaYybiMSBFhG/xSSCVmoXtFH5sbeEzsrr2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Kocoloski <brian.kocoloski@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/181] drm/amdkfd: Fix improper NULL termination of queue restore SMI event string
Date: Thu, 15 Jan 2026 17:48:30 +0100
Message-ID: <20260115164208.559844976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a499449fcb068..d2bc169e84b0b 100644
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



