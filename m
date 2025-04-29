Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001A248889;
	Tue, 29 Apr 2025 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949724; cv=none; b=XV9KetTgdrrzODuxX/hJO6AFITUvXOdjbgwtXNQhCHmNJe/4jBrjhx7cExlMfCG+T9ab9GgbBtj3E0OdMkSAbDAfa54NrNkMOYXl6vmL+ZBrjAU593t8tXADJFEICItWDL5EuVg8VQBzZAEhJc9YgqIAJZMKVrzVWU3qzUFJsvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949724; c=relaxed/simple;
	bh=kKSsabTdQ2kC9z0xZMX2XTcfMYOWpnMyyABinqLRokA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvZTvd5UX2f7Qyfxd8jeqaB4OUFDPKzLW+UYmcuhFceoY/u1wPILXw2MyKk/5WZOkEuU3b8NbI3A+EkMk7qe02TyVzEK0uGtJDhUe6IAQ+FSBkQF9xWEypSNSK773/jmuVpvnjtyR4yYLz69w1mRsifdpNuuzq7rQG5pt4uYoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MlgYHpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MlgYHpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2578C4CEE3;
	Tue, 29 Apr 2025 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949724;
	bh=kKSsabTdQ2kC9z0xZMX2XTcfMYOWpnMyyABinqLRokA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MlgYHpk/PaT92HHX1Xua6lNqtpwIHdIId/b+nkjBxYed1X8ZMbEAuXA743OAVsJt
	 2SiDFWIzdBv16SzHz4/1TlOpZnfPTrIMypT/z+65iTH43u1VBuZ7IB5prp6aT8d1Le
	 gFLqkeC7UbCuYpx4KNBwVzI64jONJIAqjjHbiSC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/167] s390/sclp: Allow user-space to provide PCI reports for optical modules
Date: Tue, 29 Apr 2025 18:42:25 +0200
Message-ID: <20250429161053.255937285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit e9ab04490667249633fb397be17db46a8fa6d130 ]

The new SCLP action qualifier 3 is used by user-space code to provide
optical module monitoring data to the platform.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: aa9f168d55dc ("s390/pci: Support mmap() of PCI resources except for ISM devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index a3e5a5fb0c1e7..c3466a8c56bb5 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -27,6 +27,7 @@
 #define SCLP_ERRNOTIFY_AQ_RESET			0
 #define SCLP_ERRNOTIFY_AQ_REPAIR		1
 #define SCLP_ERRNOTIFY_AQ_INFO_LOG		2
+#define SCLP_ERRNOTIFY_AQ_OPTICS_DATA		3
 
 static DEFINE_MUTEX(sclp_pci_mutex);
 static struct sclp_register sclp_pci_event = {
@@ -116,6 +117,7 @@ static int sclp_pci_check_report(struct zpci_report_error_header *report)
 	case SCLP_ERRNOTIFY_AQ_RESET:
 	case SCLP_ERRNOTIFY_AQ_REPAIR:
 	case SCLP_ERRNOTIFY_AQ_INFO_LOG:
+	case SCLP_ERRNOTIFY_AQ_OPTICS_DATA:
 		break;
 	default:
 		return -EINVAL;
-- 
2.39.5



