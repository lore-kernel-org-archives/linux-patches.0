Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018617;
	b=JRzpymwZLQa1yt+A8qUFFcLscuH2pMBebyDfPnE14vVi//ykscvqltiZz86Az7YAeozC
	 M+xnGwUUmqMnFGz69TJsCl7ivF0m6xDoZTgdKlcEByC0Zs4BXzhTkwNE/n8CZQ+ebAd48
	 w0vGk1Mt1gRRu9lKnceDa9LbP7FWMOTXR7F64GyYfmETPwZNzdj+KYLNuXqDh2EfpRGoi
	 M4EUmzRR5Yd3A160QLEOGcwc8W+lBiqJ0E84iHCSHpr8BXWY0MCoK9JbwovVmsZET7RZT
	 Z6wotGZocEKg2O8qN6J/f9wAxgTumOI5BhENcgdnoAMdQqBq7/dTmAsmYfEj/5MunTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5MZLfFqrldVsslFn3dYJCtGOt8GlYJqESq43x4TS0E=;
	b=kdSeOV8QlsYNkbNGZKkKzNhuk2OXj6mb6ruMraTEn6DXJtEj3juyrwKwZ0cZuz/RaPpO
	 61PJjgqzCrbYdqfO/iL70QSzoJFS2N3cV5vfE+A20PHiTfaYO2jQ1wZJW5OKP3KEIGgUo
	 lg69hgOhwo0EY3ZqG6gEr64VZttB94LG7Jm3kmp5sQIezxUziRTsA3puJMI890g8fHjtl
	 AqgHpndY9EaBFrxn7pnZFVEKpiYGAnObEZAA9oYF8Gq9GQ9rPl5Xk1DWYwolYEJhyje/L
	 4Whb4+00kbbOwNRsHKNKaoEkkRHnSpAjDgq/kQ+UnWsxifbmz2lI/5IA+o4Bo1eIXNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtsJL9Qg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB8606A33A;
	Wed, 18 Nov 2026 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtsJL9Qg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E6C1F000C6;
	Wed, 18 Nov 2026 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018617;
	bh=i5MZLfFqrldVsslFn3dYJCtGOt8GlYJqESq43x4TS0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtsJL9QgtBiSNthoxQZ72P/YPRgBAIqmxJVGQH2QQSmTtm4xHiqB3qhA9Cr1F3yyB
	 S6UhWCBjG2gmEuiSwnttPmuH0IbvtDtKcWeK47p+/Z3ysqId0lftpnr5jcBO87jlA+
	 aAdyjHRjP95xthRQ5arLDtfw1GDcQe1v2O3m5gNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1302/2651] firmware: qcom_scm: handle empty PAS resource table
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118150334.839103539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 324103eb65ba26704c2293d9daaa15c0dc022930 ]

The PAS resource-table query may successfully return a zero-sized
table. kmemdup() with a zero length returns ZERO_SIZE_PTR,
which is stored in rproc->table_ptr. The remoteproc core then
dereferences this invalid pointer while processing resources.

Treat a zero-sized result as an absent resource table and return
NULL after releasing the TrustZone memory buffer. This allows the
remoteproc core to skip resource-table processing.

Fixes: 8b9d2050cfa0 ("firmware: qcom_scm: Add qcom_scm_pas_get_rsc_table() to get resource table")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921195636.1925869-2-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 3eaa4c9ccf3cc..5fbd828f887fb 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -865,6 +865,14 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 		goto free_input_rt;
 	}
 
+	*output_rt_size = size;
+
+	/* A zero-sized table means that TrustZone has no resource table. */
+	if (!size) {
+		tbl_ptr = NULL;
+		goto free_output_rt;
+	}
+
 	tbl_ptr = kmemdup(output_rt_tzm, size, GFP_KERNEL);
 	if (!tbl_ptr) {
 		qcom_tzmem_free(output_rt_tzm);
@@ -872,7 +880,7 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 		goto free_input_rt;
 	}
 
-	*output_rt_size = size;
+free_output_rt:
 	qcom_tzmem_free(output_rt_tzm);
 
 free_input_rt:
-- 
2.53.0



