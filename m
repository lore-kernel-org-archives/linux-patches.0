Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7A5282E1;
	Tue, 12 Aug 2025 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022854; cv=none; b=PrymVxwgb19bfNHmyQodQaYuXOyVJ7/SxiZ2GujK9YlSp/jXSSyq20670urADY12qwLRQCRcsOtgfqjuheKXDT3ysATHcjbQ4fqHWNGqaX+YDkexuVTO/fEq2k/dS+JWkv0Xq3+rApP/XpoT36pDtWPjjadXWUdgPhiFgYrql/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022854; c=relaxed/simple;
	bh=1AN1pjb8DJxe7v7V6/X3r7MJxKB0M/yP1SLQjd7QB/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mkss/XndrQnH5sF2wJxUGiq3fPbUYgZs5jcBtTP5rzVk26qXSd+q/BL+xwPB2ILs0DUzED5WpcBvrVzUIQ5Q9Qmd/WcDBri+SfA8TEETCS+dwuRIKsRp9POcAEoX0mVOuvZQlFUvt7NlDoeM7cC1GzBiLCgUn08eCBO/pY3ewwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCDLhnkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCDLhnkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B81AC4CEF1;
	Tue, 12 Aug 2025 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022854;
	bh=1AN1pjb8DJxe7v7V6/X3r7MJxKB0M/yP1SLQjd7QB/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCDLhnkZxYyhJDwxfk2fT6HQwyz5yfjO91XaZlIskGJYPi6jAGRjli2iyBiopQWfn
	 JEFNWY/GhtcTSsQId+Y5pamhz0S4xggQsF9yWXHPTQljkNHlQhztKm0GY7FynnZ/CM
	 aKMS9GGcJAD12g6I+CY1j8RSzNKTqg7dvT/bgIHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/369] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 12 Aug 2025 19:29:34 +0200
Message-ID: <20250812173026.030633786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit e82b34eed04b0ddcff4548b62633467235672fd3 ]

The PowerNV hotplug driver needs to be able to clear any frozen PE(s)
on the PHB after suprise removal of a downstream device.

Export the eeh_unfreeze_pe() symbol to allow implementation of this
functionality in the php_nv module.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/1778535414.1359858.1752615454618.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index ca7f7bb2b478..2b5f3323e107 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1139,6 +1139,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



