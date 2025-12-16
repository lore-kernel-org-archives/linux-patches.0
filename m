Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC6C363C65;
	Tue, 16 Dec 2025 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886939; cv=none; b=Tly+cVRS8VtqeGS6rGqn0b/YYpdBI/Cg+kky7HZL95DtLTik5d4I95pW7xt7fu9iS8JAn+wBv6nrpP4gAubukHFgJUbAJEaORCp4VWTIraDrhSzwKtp7X1TlJrX3n7xxn88gcwB1zp/6PRrxpQLreknds6Tyuf0C8JxoqjJ7mpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886939; c=relaxed/simple;
	bh=BPoFZMtVRDMou5jFxNK45qDIsXBP9eYZircTGQgkQ4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhNK/z3A5XvttZaWf3Ahx17qSHAvW6Pfu+JkH9pfllmAWmKWaCmxiI0h0SnwLfgXuIkjkylQFEaemYrUwuAalWMzs17paUKCbL3wCEnVhtpjj8z0P3jeoxRibcByAtym3XhsbGDGh6ea6bBRTJO9nZ4WP2NtgrgFQS4vb3PKBts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/ud0qeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/ud0qeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65179C4CEF1;
	Tue, 16 Dec 2025 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886938;
	bh=BPoFZMtVRDMou5jFxNK45qDIsXBP9eYZircTGQgkQ4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/ud0qeGzc23RGhSH+nsHmc6h1PPO8wx77w3keP0EPjnEHOIpFmB9OYr2jxMrxCuK
	 awRVKAUo6/jPm7y2KrTeUGQqTvwCbybOWOe3tYr0u+RiKxoxAWNXIKPcyiXwrEmwCP
	 QBklTaS6tKy3gnjCFE3PS4ZkvhUZEW4wXred5ztk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/614] firmware: qcom: tzmem: fix qcom_tzmem_policy kernel-doc
Date: Tue, 16 Dec 2025 12:07:08 +0100
Message-ID: <20251216111403.522671111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit edd548dc64a699d71ea4f537f815044e763d01e1 ]

Fix kernel-doc warnings by using correct kernel-doc syntax and
formatting to prevent warnings:

Warning: include/linux/firmware/qcom/qcom_tzmem.h:25 Enum value
 'QCOM_TZMEM_POLICY_STATIC' not described in enum 'qcom_tzmem_policy'
Warning: ../include/linux/firmware/qcom/qcom_tzmem.h:25 Enum value
 'QCOM_TZMEM_POLICY_MULTIPLIER' not described in enum 'qcom_tzmem_policy'
Warning: ../include/linux/firmware/qcom/qcom_tzmem.h:25 Enum value
 'QCOM_TZMEM_POLICY_ON_DEMAND' not described in enum 'qcom_tzmem_policy'

Fixes: 84f5a7b67b61 ("firmware: qcom: add a dedicated TrustZone buffer allocator")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20251017191323.1820167-1-rdunlap@infradead.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/qcom/qcom_tzmem.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/firmware/qcom/qcom_tzmem.h b/include/linux/firmware/qcom/qcom_tzmem.h
index 48ac0e5454c7f..23173e0c3dddd 100644
--- a/include/linux/firmware/qcom/qcom_tzmem.h
+++ b/include/linux/firmware/qcom/qcom_tzmem.h
@@ -17,11 +17,20 @@ struct qcom_tzmem_pool;
  * enum qcom_tzmem_policy - Policy for pool growth.
  */
 enum qcom_tzmem_policy {
-	/**< Static pool, never grow above initial size. */
+	/**
+	 * @QCOM_TZMEM_POLICY_STATIC: Static pool,
+	 * never grow above initial size.
+	 */
 	QCOM_TZMEM_POLICY_STATIC = 1,
-	/**< When out of memory, add increment * current size of memory. */
+	/**
+	 * @QCOM_TZMEM_POLICY_MULTIPLIER: When out of memory,
+	 * add increment * current size of memory.
+	 */
 	QCOM_TZMEM_POLICY_MULTIPLIER,
-	/**< When out of memory add as much as is needed until max_size. */
+	/**
+	 * @QCOM_TZMEM_POLICY_ON_DEMAND: When out of memory
+	 * add as much as is needed until max_size.
+	 */
 	QCOM_TZMEM_POLICY_ON_DEMAND,
 };
 
-- 
2.51.0



