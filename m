Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D9F34E76A;
	Tue, 16 Dec 2025 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886292; cv=none; b=SmANCDqEnfL0SpI8s31Wcn6b2cgNdt5nCeFAvSug4k0taG0IeCiXHtmdo3foC07U95Ek5mna/QSq205QiB1xOjoEIs04JPv0+eSQRqrKy1q3tcgRrfrrF+w2iYe7YQPHEgPHPjjKu8JxESrEhSBef4kG8e1/vbgym55cIiZEmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886292; c=relaxed/simple;
	bh=JvaMvcJn0I0Zq8JDTyMSTgvgZ4rgPwHSFi2Q6KjQOh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R38i3p7XHyUg8uIVPiEU3yEMPi83qJpGbWgBxVNw03Sk1FcCKV88ZVA3e7MNllgbjoPSCoPob31gv40qrGt0uMIK89kdI5P8K9OqleA2vrt/iu/MuNC8B1HnddPJv+MxRM4B5CEw5OYsa37o1FEJlT4NL2y48kwzdI7q2Q7yEIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpaMwqvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpaMwqvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9719C4CEF1;
	Tue, 16 Dec 2025 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886292;
	bh=JvaMvcJn0I0Zq8JDTyMSTgvgZ4rgPwHSFi2Q6KjQOh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpaMwqvEJ/5QdGvaXe1PDrPMMN8XVz8VBCe7/heXADd6WdDOlAtoeam8k3lGvDaE0
	 l8CJLUrrepJowWRWYmWkhFPt2lva3IgrJ9h0VYEXa641klEG4dzmq60+ytgoIqFbKV
	 mjuGCU+H4j0Cwaxzi2OeaGsGzwV6gpiizQ0fq+ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tim Hostetler <thostet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 395/507] iavf: Implement settime64 with -EOPNOTSUPP
Date: Tue, 16 Dec 2025 12:13:56 +0100
Message-ID: <20251216111359.763554914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 1e43ebcd5152b3e681a334cc6542fb21770c3a2e ]

ptp_clock_settime() assumes every ptp_clock has implemented settime64().
Stub it with -EOPNOTSUPP to prevent a NULL dereference.

The fix is similar to commit 329d050bbe63 ("gve: Implement settime64
with -EOPNOTSUPP").

Fixes: d734223b2f0d ("iavf: add initial framework for registering PTP clock")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Tim Hostetler <thostet@google.com>
Link: https://patch.msgid.link/20251126094850.2842557-1-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ptp.c b/drivers/net/ethernet/intel/iavf/iavf_ptp.c
index b4d5eda2e84fc..9cbd8c1540318 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ptp.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ptp.c
@@ -252,6 +252,12 @@ static int iavf_ptp_gettimex64(struct ptp_clock_info *info,
 	return iavf_read_phc_indirect(adapter, ts, sts);
 }
 
+static int iavf_ptp_settime64(struct ptp_clock_info *info,
+			      const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 /**
  * iavf_ptp_cache_phc_time - Cache PHC time for performing timestamp extension
  * @adapter: private adapter structure
@@ -320,6 +326,7 @@ static int iavf_ptp_register_clock(struct iavf_adapter *adapter)
 		 KBUILD_MODNAME, dev_name(dev));
 	ptp_info->owner = THIS_MODULE;
 	ptp_info->gettimex64 = iavf_ptp_gettimex64;
+	ptp_info->settime64 = iavf_ptp_settime64;
 	ptp_info->do_aux_work = iavf_ptp_do_aux_work;
 
 	clock = ptp_clock_register(ptp_info, dev);
-- 
2.51.0



