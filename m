Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061196;
	b=4ZJ/URekUDZ1Evk+pb+eAjIdDxmnqCYyfSOOUieDlH4Jj9Ks2Rn54Fxiwb3V1NQoIx51
	 Df9JJvZ9P8wfecSxm2IcxQU0bSaAIUFW3ZzYQhbYcKreYkx6yBswOiqR/UHX0DKHFzsBx
	 kzt02Mfnw1x6NSwiTqKIWU9pR/cZ50xPdAMsicEbPjh6q8GxfNG2pzrx5JBRmSjl3xmQx
	 MSN+q6QnOOd2dsQiPK7FyJUuym9UpU28rKWPaM1kkc2tyMDYeeOGmKUhRHJhtvGLndBWm
	 XBNdQXpEp4amKThq9hEdmZatTNGKMtDOr80C8WaLyiLXlepgRbar+DgLbLgacjU41tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fz8hKbgP4Hh/BRfIc5s21C30R9nJQGnJIPqCWyiv+3s=;
	b=hyeX/LUvX1Ab8c1rgrnxEUE+kRsKO8xJlOtWvs0LXJawR/2jSvkq5bRnlqgnsi9JvPLa
	 dPtdNWNqCi6JcAmhb7FCh6HuiCJAspgZix0Keam4YXAZ2C/bDnfGckKqXjxOKttcZJ1Lb
	 pbzJDlF/RCsTNproUl+Y5yKV9Sgl1FrmDfYnybCVJXCnAziMK9sTF8bv1S/lSCsEa/k8f
	 Sbqd3kd2kdK868uUxk4+uwOt2MpNuG7CL3FgZCc/2xhnoyjaxxmUwurrQllsh/Zq2jDz/
	 uUrvH0zWJFyUXmpz2KGQH1lmQT7LWGRrXx5lxCGzKcNnEtbmnzO5nt4Iv3LuRokqUuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gbp1DFi/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CBB606A326;
	Thu, 19 Nov 2026 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbp1DFi/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDAD1F000C4;
	Thu, 19 Nov 2026 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061195;
	bh=Fz8hKbgP4Hh/BRfIc5s21C30R9nJQGnJIPqCWyiv+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbp1DFi/kvaRYFnnM6/A+3CJtFHb7meI8ohE/mLF3Tryyxc6EdzvEJSN+/oIK3k+6
	 dW1o4gojUkcx3lkPAYJVlq6o87i+LOfPnXpshEDwnrGLz8oGPKa4wSlFm5n7KCiMK3
	 Qp6HCIZ59AYMCgEal68bsKXNddYVcYsrmaZX/zn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1425/1848] ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150019.195464387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 27b98d331f1dcebe088ab51a7061a387a7440cb2 ]

vexpress_smp_dt_prepare_cpus() obtains a reference to the SCU device
node via of_find_matching_node() and passes it to of_iomap(), but never
calls of_node_put() on it. of_iomap() does not take ownership of the
node, so the reference is leaked. The function is the .smp_prepare_cpus
hook invoked once from the __init SMP bring-up path, so this is a
one-shot leak of a single refcount during boot, with no functional
impact.

Annotate scu with the __free(device_node) cleanup attribute so the
reference is released when the function returns.

Found while reviewing a CodeQL report for vexpress_flags_set() on the
same SMP bring-up path.

Fixes: d2606f81d563 ("ARM: vexpress: Simplify SMP operations for DT-powered system")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260925173252.933705-3-geoffreyhe2@gmail.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 99c93124aa68d..acc7473515e39 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -64,8 +64,8 @@ static const struct of_device_id vexpress_smp_dt_scu_match[] __initconst = {
 
 static void __init vexpress_smp_dt_prepare_cpus(unsigned int max_cpus)
 {
-	struct device_node *scu = of_find_matching_node(NULL,
-			vexpress_smp_dt_scu_match);
+	struct device_node *scu __free(device_node) =
+		of_find_matching_node(NULL, vexpress_smp_dt_scu_match);
 
 	if (scu)
 		scu_enable(of_iomap(scu, 0));
-- 
2.53.0



