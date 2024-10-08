Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0CB1DC759;
	Tue,  8 Oct 2024 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391353; cv=none; b=XZqYY7g1Rt7lfPntGTQ5iWeGSE1Lf+pXdk6rmAspnTkWQbz9mKlc4vbnTeF5xo5qoFSacczJvSFSKCWRBrfjVI+2j8BbPGvXV/Lto96b2x2JsyHNOqJqger+KCupgu7qKGiZh3kJydz07/ljgorgSV74fwUfDbo8gZgxXqL2N8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391353; c=relaxed/simple;
	bh=MCwbHyMnBR/U+EuvHddpR8nBgSh3HiTPxuQ8KvDuA9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxGyVT1lLrdTWHgF3NlobHULSEBX1rMzjAfNtQ3KbGTb2Fuh/yPDNUE8GLslPONav8SpN1ROwy8lqZqsrtKt2CXIoCu4fxs+23RIKYzDLjeN8bA06UwdpaHLkxFT+FnfqfnHG8nePlITGH2f56AMFW8o50bWhMJUMi/QB9yIq8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnXqz51K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnXqz51K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115CCC4CECD;
	Tue,  8 Oct 2024 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391353;
	bh=MCwbHyMnBR/U+EuvHddpR8nBgSh3HiTPxuQ8KvDuA9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnXqz51KffTqfyN/pbDO/ZVinTNKTXZ2an2EL6KUJE0lo62LO3K63cymc0hiXMzf+
	 kedMOe7ldFb1OKEQ3m4lbw2nXUrgBWMuZn0Is7BqoXeuPacrBLCXoDAXx08tA5cdba
	 QFTV/fOVKDd4gWtHu8pVQ88/An14egnhVwknYyr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 070/558] drm/xe: Restore pci state upon resume
Date: Tue,  8 Oct 2024 14:01:40 +0200
Message-ID: <20241008115704.970542256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 732ee0d02124f..5929ac61dbe0a 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -924,6 +924,8 @@ static int xe_pci_resume(struct device *dev)
 	if (err)
 		return err;
 
+	pci_restore_state(pdev);
+
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
-- 
2.43.0



