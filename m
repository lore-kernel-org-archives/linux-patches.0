Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829733;
	b=VZ7bjlNkBe6+Tbvo4q5UR8cOxoIOZImVm7mJo1vWw0tGgtnTDagKjgWDNKJzGxxFgpG3
	 XEs4guO21fFf821hAGHn6be4H73uuTDC5aKX2Jf4JdKa4iPfhx0cWkyiuCh2sksHEtfzt
	 Rj4YknLzuJUP1CJwcdTNTnduoxudje8FaT3yK4JeqqujcfcNyY08qG6cxvjE2yqGdJokn
	 ZgW0tlG4GXAKB/X+6jTem1D0sBU342QiJ2R06X0i5TlstvSHou+hUFG6UHOkX0TDQdACw
	 AJtxEDXQA2izcx7xAQiTeb7XeqXbXLlrfXKNaE2zl7dekij5hWISReuKDp2hzvQ9UYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkoUIwtZ/s0mCagz5VqRuMZgxBg1d3a1GyI7nit36SY=;
	b=PynRBPkGqY+GuNKlr44pkD514LwRu7/vGMI/Ngj5+y2L7OjAq4nEY2elwCvfVEqikTD4
	 7wA3KkUvJku6CEkEMAAuo+2ZfLhpwa5LP1YMTetH4BLBrC1lP28FTKrQVGjNVMCFBnDcC
	 ENYteFPH1PMRH15VH/WpYkwxuEYhvXIXhX/AJtt73cFxdIfsrKc0Lz1B+AXn5iXL9fIQF
	 XyugT9J6sASAdbSeUgifyvxBZNnrYWh+XO6u9US5oWzYonmtgtew57SEpW0OcppRcKPxY
	 K+rBwWWxAIf/zVSiW8y4SDc+ZQSNZB23MMTpUrY86Ko+9tygjNxqnMqouNXcyww7Z/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zb71tUbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1872606C5BC;
	Wed,  4 Nov 2026 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zb71tUbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD31F000C1;
	Wed,  4 Nov 2026 22:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829732;
	bh=LkoUIwtZ/s0mCagz5VqRuMZgxBg1d3a1GyI7nit36SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb71tUbcg7FPM1hd8FksBtnVO2CBfhaSVHN9wuYXxRaGpLd27CnpCen94ValZwdgA
	 F4J78mEcz1YfFuOeBg8CjNFezAbZbQRJgJA6ImgUL4DWLWmFC76InqsfuiTzEu3jh3
	 fHrnvnP+9a9m2d1pESzresCu4VYH3Ccq7aMC/taI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0259/1005] remoteproc: Force shutdown during device removal
Date: Wed,  4 Nov 2026 15:59:52 -0500
Message-ID: <20261104211051.123289284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 4059c64d78b5d543dabae332922e763b4c95c79e ]

rproc_del() is subjected to the reference counted shutdown path, as such
a remoteproc with more than one reference will be left running as its
resources are released underneath it.

Refactor the shutdown path such that the reference count value is
ignored when called from rproc_del().

Assisted-by: OpenCode:GPT-5.5
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-rproc-rmmod-not-crashing-v1-3-546dfd5de0e6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 57 +++++++++++++++-------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 70c990c3a5d76..1e277333de871 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1993,28 +1993,7 @@ int rproc_boot(struct rproc *rproc)
 }
 EXPORT_SYMBOL(rproc_boot);
 
-/**
- * rproc_shutdown() - power off the remote processor
- * @rproc: the remote processor
- *
- * Power off a remote processor (previously booted with rproc_boot()).
- *
- * In case @rproc is still being used by an additional user(s), then
- * this function will just decrement the power refcount and exit,
- * without really powering off the device.
- *
- * Every call to rproc_boot() must (eventually) be accompanied by a call
- * to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
- *
- * Notes:
- * - we're not decrementing the rproc's refcount, only the power refcount.
- *   which means that the @rproc handle stays valid even after rproc_shutdown()
- *   returns, and users can still use it with a subsequent rproc_boot(), if
- *   needed.
- *
- * Return: 0 on success, and an appropriate error value otherwise
- */
-int rproc_shutdown(struct rproc *rproc)
+static int __rproc_shutdown(struct rproc *rproc, bool force)
 {
 	struct device *dev = &rproc->dev;
 	bool crashed;
@@ -2034,9 +2013,10 @@ int rproc_shutdown(struct rproc *rproc)
 	}
 	crashed = rproc->state == RPROC_CRASHED;
 
-	/* if the remote proc is still needed, bail out */
-	if (!atomic_dec_and_test(&rproc->power))
+	if (!atomic_dec_and_test(&rproc->power) && !force) {
+		/* The remote processor is still needed by another user. */
 		goto out;
+	}
 
 	ret = rproc_stop(rproc, crashed);
 	if (ret) {
@@ -2060,6 +2040,32 @@ int rproc_shutdown(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 	return ret;
 }
+
+/**
+ * rproc_shutdown() - power off the remote processor
+ * @rproc: the remote processor
+ *
+ * Power off a remote processor (previously booted with rproc_boot()).
+ *
+ * In case @rproc is still being used by an additional user(s), then
+ * this function will just decrement the power refcount and exit,
+ * without really powering off the device.
+ *
+ * Every call to rproc_boot() must (eventually) be accompanied by a call
+ * to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
+ *
+ * Notes:
+ * - we're not decrementing the rproc's refcount, only the power refcount.
+ *   which means that the @rproc handle stays valid even after rproc_shutdown()
+ *   returns, and users can still use it with a subsequent rproc_boot(), if
+ *   needed.
+ *
+ * Return: 0 on success, and an appropriate error value otherwise
+ */
+int rproc_shutdown(struct rproc *rproc)
+{
+	return __rproc_shutdown(rproc, false);
+}
 EXPORT_SYMBOL(rproc_shutdown);
 
 /**
@@ -2626,8 +2632,7 @@ int rproc_del(struct rproc *rproc)
 	if (cancel_work_sync(&rproc->crash_handler))
 		pm_relax(rproc->dev.parent);
 
-	/* TODO: make sure this works with rproc->power > 1 */
-	rproc_shutdown(rproc);
+	__rproc_shutdown(rproc, true);
 
 	rproc_delete_debug_dir(rproc);
 
-- 
2.53.0



