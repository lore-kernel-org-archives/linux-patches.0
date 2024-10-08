Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C97C1DE2D9;
	Tue,  8 Oct 2024 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389674; cv=none; b=dDTtXY+o1StD3ZlKfLgyCmrwE3wGrpSDOgkx13QzZ64aBJ+CqSPpEE7RISlF14zHnkD8QL8TZty79gU12T4lidUls/ShF9+l6VW2hbisW8eWTr4eCLG9spR7t7twjEFUfFStQvE6XapXNOXbSy1w0JaHX7EMD7hIPikDEDhRHE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389674; c=relaxed/simple;
	bh=4/eP90sfUzSFsHaUHhdsKHYdJcvbfP9rBTzSBx2+Ins=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrISkXGEe/RSbxxAW0AtJqW/07hVEOZZ/XxEY8jbIQyTR45l5NSWiqExYaReODFU61SBtqNghLy1VTDK+dRP0a8DiBXPBsarmSFv8ZMhlL1ww05mNMT6orUmanP/byAinUNqqALBGzl5R0R9kf+9YhaeuL+vtigGprC/gWKcFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9/+xP7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9/+xP7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF9EC4CEC7;
	Tue,  8 Oct 2024 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389674;
	bh=4/eP90sfUzSFsHaUHhdsKHYdJcvbfP9rBTzSBx2+Ins=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9/+xP7Bh3ft0MMN3VUr+5YH+sUNvHMfWh4cYYeXbR7QqwWi0xbb8bRBq+D250USq
	 q99xHlBNP6o35I6OGKZQfP+xbFZQgMt89BmCF1YjgTUtvliUUw+UINe/zKkiL3H6my
	 ULtcK2L8q0l48+BRDtapVN4IFTh2UWt4ySL4Iwok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 063/482] drm/xe: Restore pci state upon resume
Date: Tue,  8 Oct 2024 14:02:06 +0200
Message-ID: <20241008115650.788017475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit cffa8e83df9fe525afad1e1099097413f9174f57 ]

The pci state was saved, but not restored. Restore
right after the power state transition request like
every other driver.

v2: Use right fixes tag, since this was there initialy, but
    accidentally removed.

Fixes: f6761c68c0ac ("drm/xe/display: Improve s2idle handling.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912214507.456897-1-rodrigo.vivi@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
(cherry picked from commit ec2d1539e159f53eae708e194c449cfefa004994)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index f326dbb1cecd9..99824e19a376f 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -868,6 +868,8 @@ static int xe_pci_resume(struct device *dev)
 	if (err)
 		return err;
 
+	pci_restore_state(pdev);
+
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
-- 
2.43.0



