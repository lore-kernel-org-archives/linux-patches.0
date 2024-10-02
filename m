Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E41CF28B;
	Wed,  2 Oct 2024 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875309; cv=none; b=ljWONeeHIgh1vhpZ7X8L/qGBvyOOJOPpCTCZPeN7Amr1067j8jAixY36WQx1k9svxtVsYiPz3ZYwGUyMw0w4FY6fiOEJ70bZr7owsaEIZB9CZnFShiSB1TCTvW3FZT6cVxvhWiGmvO6OeNJE1TpUyG6hcBupCu9bjFRrtnuqVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875309; c=relaxed/simple;
	bh=9QExpTfXiMAZRMnxBKnnWdPgBawxJicq/E85Gywec9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjbRr5c+R78mmn4AU+em1b4Jga+DdNddr/b12iwR5bVFHI6+qkzahqw3gaYEIvCb/IrACq4ZzflBn3I22CS/aDQd7Axi2q6KUU7KG96+5c4naS1XztjX1gESNb2Wamuq1t6PRic0fl8nXHHKdlEov7szpSb9d7n2/nFRwb1W7oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRE1BMjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRE1BMjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25111C4CEC5;
	Wed,  2 Oct 2024 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875309;
	bh=9QExpTfXiMAZRMnxBKnnWdPgBawxJicq/E85Gywec9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRE1BMjvuv3ujh7EU92CaSOoQQDoIOC6g742iEKIxDM/mbl4gp31qmQHiP7wirdJz
	 Mn5dim+f6VV1lThnsTxf+Kf/xNV37udHY14moaWJfPsFq+Zq2N3cY14GGnAZ33c6ZY
	 IrsJBoFuzEcCz0VhUu+rnKCDmLjNaS2LoyF1mme0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 059/695] kselftest/arm64: Actually test SME vector length changes via sigreturn
Date: Wed,  2 Oct 2024 14:50:57 +0200
Message-ID: <20241002125824.840485034@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 6f0315330af7a57c1c00587fdfb69c7778bf1c50 ]

The test case for SME vector length changes via sigreturn use a bit too
much cut'n'paste and only actually changed the SVE vector length in the
test itself. Andre's recent factoring out of the initialisation code caused
this to be exposed and the test to start failing. Fix the test to actually
cover the thing it's supposed to test.

Fixes: 4963aeb35a9e ("kselftest/arm64: signal: Add SME signal handling tests")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20240829-arm64-sme-signal-vl-change-test-v1-1-42d7534cb818@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testcases/fake_sigreturn_sme_change_vl.c       | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
index cb8c051b5c8f2..dfd6a2badf9fb 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
@@ -35,30 +35,30 @@ static int fake_sigreturn_ssve_change_vl(struct tdescr *td,
 {
 	size_t resv_sz, offset;
 	struct _aarch64_ctx *head = GET_SF_RESV_HEAD(sf);
-	struct sve_context *sve;
+	struct za_context *za;
 
 	/* Get a signal context with a SME ZA frame in it */
 	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
-	head = get_header(head, SVE_MAGIC, resv_sz, &offset);
+	head = get_header(head, ZA_MAGIC, resv_sz, &offset);
 	if (!head) {
-		fprintf(stderr, "No SVE context\n");
+		fprintf(stderr, "No ZA context\n");
 		return 1;
 	}
 
-	if (head->size != sizeof(struct sve_context)) {
+	if (head->size != sizeof(struct za_context)) {
 		fprintf(stderr, "Register data present, aborting\n");
 		return 1;
 	}
 
-	sve = (struct sve_context *)head;
+	za = (struct za_context *)head;
 
 	/* No changes are supported; init left us at minimum VL so go to max */
 	fprintf(stderr, "Attempting to change VL from %d to %d\n",
-		sve->vl, vls[0]);
-	sve->vl = vls[0];
+		za->vl, vls[0]);
+	za->vl = vls[0];
 
 	fake_sigreturn(&sf, sizeof(sf), 0);
 
-- 
2.43.0



