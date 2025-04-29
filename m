Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD2244668;
	Tue, 29 Apr 2025 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948261; cv=none; b=gqhtTZVNea5zzCHEZmt6AA6Zhj43yymKdUc8FY5iHnELDauCWqwLmHRT7hmonWZH+UrY6VCsiNVuqKBY01jIhV6tpRJovYC+578DjaHfcMBTvlfCzogUEmh2PVMpm+CCS/dZ3EfzElDdUpfZVYm0Mn1d3WK6TI1BnOww39u1vaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948261; c=relaxed/simple;
	bh=0xkIC7Ep52fkC48TIMC4kOA6CkTizslBfWJJMOFNqS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASCAUOSjTWC4f/oi3sk4gFWr1tzh0Rhivs3P+q+iCdfpJpRHF87Q2Wg1AwlMpKY1F+TmvBUODVoMSihdY4TDMAhI/04evmv6z26cS/lIih+YUh4HG5BZGksM3tLpohOxfSyd6UufRYrKvOaMDRbyQtNICx85rve6llHPEtBN85w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHgCBzTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHgCBzTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B0EC4CEE3;
	Tue, 29 Apr 2025 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948261;
	bh=0xkIC7Ep52fkC48TIMC4kOA6CkTizslBfWJJMOFNqS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHgCBzTRwh6jea47HLrT/M6jL3kcZULnZihpj5AqGZhzMhLv3miQ+qcLtKHl7euU5
	 dEoYOXiE1fvOy6frrLCVjFIDWjKGoshOISIDbAbpWbKeLxy1aS72kWA3ykIrQYBNek
	 MCe4cDj1IsjVvGppWOfp1Vdz06XS64cAnokh4KTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/280] xen: Change xen-acpi-processor dom0 dependency
Date: Tue, 29 Apr 2025 18:42:27 +0200
Message-ID: <20250429161123.558907573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 0f2946bb172632e122d4033e0b03f85230a29510 ]

xen-acpi-processor functions under a PVH dom0 with only a
xen_initial_domain() runtime check.  Change the Kconfig dependency from
PV dom0 to generic dom0 to reflect that.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250331172913.51240-1-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index f7d6f47971fdf..24f485827e039 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -278,7 +278,7 @@ config XEN_PRIVCMD_EVENTFD
 
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
-	depends on XEN && XEN_PV_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
+	depends on XEN && XEN_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
 	default m
 	help
 	  This ACPI processor uploads Power Management information to the Xen
-- 
2.39.5



