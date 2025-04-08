Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9378C264FA0;
	Tue,  8 Apr 2025 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110865; cv=none; b=j35sUyDmYr23vmsEpQI+8aE77YDQyme39DGw/g358sBR+BViOx4hV54PI5HFJclmkaAfIKRLnOTmQ4oIH6jxZvXyy+r3n3UX4q3vJt/8DeWnhsA+uHI1AM6iomEJOa4gmPFEtv/73f2g7rnBDDSEwexdMqN6keSoy4XtdN8mWNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110865; c=relaxed/simple;
	bh=V/WOyLXgsR1l1JDbv0LuWZas7UN53lB2zHweVAzmePk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXE3ZIdbtZacfuEi107H9C658kenTdmtzJE1cditFCQjdtEB8lT4lHRVjxVVSCOC16Mis/DW4U58FiNE/5Kqj44pIY5PQNxdZcFM1ongVd+RaalqJ2rvIZs88OHN3Bkh1MZ3lHjdAjiZPrJaBhTULwW/ywJbtUxgYSiQgPTx9+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYeTknnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYeTknnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24421C4CEEA;
	Tue,  8 Apr 2025 11:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110865;
	bh=V/WOyLXgsR1l1JDbv0LuWZas7UN53lB2zHweVAzmePk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYeTknnIXyieaUYVRGIWIzDpy+3oJCBEBGqKrIZrCKcm/Sy9aPzajT3jsZTZwioYA
	 UTDtgjJIYYYbEvGfv6Al3Ggm6ujDtOxo8tepKGRxy8C0yUz6nUuSTwyJzzJBP4jwOt
	 g1EmEdNvgdqqR+9x815GhlhnCFdz5LLMMfJ/xJ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 224/731] ptp: ocp: reject unsupported periodic output flags
Date: Tue,  8 Apr 2025 12:42:01 +0200
Message-ID: <20250408104919.490940942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 8dcfc910a81d8b53f59f8b23211e81f2a91f84f9 ]

The ptp_ocp_signal_from_perout() function supports PTP_PEROUT_DUTY_CYCLE
and PTP_PEROUT_PHASE. It does not support PTP_PEROUT_ONE_SHOT, but does not
reject a request with such an unsupported flag.

Add the appropriate check to ensure that unsupported requests are rejected
both for PTP_PEROUT_ONE_SHOT as well as any future flags.

Fixes: 1aa66a3a135a ("ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250312-jk-net-fixes-supported-extts-flags-v2-5-ea930ba82459@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index b651087f426f5..4a87af0980d69 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2090,6 +2090,10 @@ ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
 {
 	struct ptp_ocp_signal s = { };
 
+	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
+			   PTP_PEROUT_PHASE))
+		return -EOPNOTSUPP;
+
 	s.polarity = bp->signal[gen].polarity;
 	s.period = ktime_set(req->period.sec, req->period.nsec);
 	if (!s.period)
-- 
2.39.5



