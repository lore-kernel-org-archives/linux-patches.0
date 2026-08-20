Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1237DE89;
	Thu, 20 Aug 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238311; cv=none; b=qqhjNDGx7eMD5wE8+zL4RYwhDWsXIoFJPPdImMZEmX75zrgB3ePGl6FL1OK7Uch1PXj+ACy5bXRA5YWNz6/ifn4DZGHey3mhfMWcqsd4Z0YZcuooWDvbgIM6ghgY3guAXThQUedT4hNuMlJLmZFGuDoAiAJ0ODHG6ZH5HiGoA30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238311; c=relaxed/simple;
	bh=NqtJMcelD7CWLHLApPeDNBWacvv3Z3bub63wPvkbvdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmUg1DP14IVn54a/K/gcYhaqir8YPnIJEyrsgOzLO4Ew9V3e9ZCmPocQ4aYFugolJqWdSKsqhPfIJHjMjVppp7xqbp/ZMl/sDDBHwrpkgrro0tDEKh4Zaz0vftbR+arx3uZls4cT4yI02Vus4pAjur3UtTDxUoq9e2oh6C/D1Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlCd0Rk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlCd0Rk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB451F000E9;
	Thu, 20 Aug 2026 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238310;
	bh=hNstC4qagYZbL0PheeV+Zt+s8XE2aBPaYau5/brv05I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlCd0Rk+HbNheqyYY62J8Bh7uRGWVWQGgBrihFb+10oe7O7sqLwgxu6nDGIVyN1o+
	 CTsKROAuJbO0UFgroolpgTNJrPsz9fEi3pXBQ5LLxllgVHvJ2F1SJKKdo/0MUPe97T
	 lkPSKqq6StC3HE/QaJKrbB2VmdYJji+klJJi5XIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 064/228] pmdomain: qcom: rpmhpd: Add missing MXC and MMCX power domains for Eliza
Date: Thu, 20 Aug 2026 16:53:26 +0200
Message-ID: <20260820145246.409241907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

commit b48a0a0a76ccecec60f0568e2af4d89994b08bec upstream.

MXC and MMCX were initially omitted as they were believed to have no
consumers, and they were not present downstream either.

The Iris video codec requires these power domains, so add MXC and MMCX
along with the MXC_AO and MMCX_AO.

Fixes: f387ecdd492f ("pmdomain: qcom: rpmhpd: Add Eliza RPMh Power Domains")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/qcom/rpmhpd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -235,9 +235,13 @@ static struct rpmhpd *eliza_rpmhpds[] =
 	[RPMHPD_GFX] = &gfx,
 	[RPMHPD_LCX] = &lcx,
 	[RPMHPD_LMX] = &lmx,
+	[RPMHPD_MMCX] = &mmcx,
+	[RPMHPD_MMCX_AO] = &mmcx_ao,
 	[RPMHPD_MSS] = &mss,
 	[RPMHPD_MX] = &mx,
 	[RPMHPD_MX_AO] = &mx_ao,
+	[RPMHPD_MXC] = &mxc,
+	[RPMHPD_MXC_AO] = &mxc_ao,
 	[RPMHPD_NSP] = &nsp,
 };
 


