Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44751043D;
	Mon, 31 Aug 2026 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183779; cv=none; b=RAxkm3RhWtGKyAQmuUu0tCemDf9dA89ShNm8TbkDJBWGInqKhS3FdLynRstvQteT8hEIy2RPWf0Fa7FGwK+baf3Ry4Et1AU/ylmP3+j0oHIgdhic/zXHrJZ5NaQJk4NhDMcg1IjJSTx48r0GnPQlK0jYIDdgTxfV4j32krwun8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183779; c=relaxed/simple;
	bh=HiZ5h2tgJi9ynNrrRVGQCp8BJER4M3f7VJqky2CQGsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0qp8Z3ByMc0KwYOkxUfW9AFvnLZVH0dswda2f1FJ9/+4zm7W/A8KcPC5IBfCg0d6daq1wJWv59rHAxR/LbZX0S8hqloPrDRp/Eyyb7Y2K/KC1lg+OmyzIMziqlfj+IUqBDyB3xYARX+8b4YG6m0TJmXgRb93jjGiiMHM8/l7DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ifd6JJxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ifd6JJxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812D21F00ACA;
	Mon, 31 Aug 2026 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183777;
	bh=UT63IEGcgs+CqB8TLZ9Ry16WusF/i8twTRNW2WaeA8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ifd6JJxEt0LJvkQpTCI9qt/HeBaaWAlZAnKVIn3ZjXuQlGI4kTlZJwy9HaeytEvEi
	 VwopthmC2oXoRRRC101ofk2sO2sLlvIuw8sjwggn2Vg1NoRMhq9w0nlupi70I81J/3
	 4/yfLdh82qUWFsi8GJHjrmaUoKmGRlobFFTeLkS/KynEPNt5vH7aPTvBU03jymrlBl
	 sWzZ7G040zkZXGTfA/meW0lLh6kLcKEhPTxhv6MXDGBBvyHyI1C1Pv8HcbQjVSthWO
	 OtYiHP0LCAGr/ZwLGDxmgfvI7lgBxxj51ckWLRa/2SvPO+Ry+f4ap2UKyyoNJihF1h
	 7EU1rfla9L4gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Mon, 31 Aug 2026 09:25:26 -0400
Message-ID: <20260831133314.4125787-298-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ikaros <void0red@gmail.com>

[ Upstream commit 0e2021f49e64b3c8a9aa880d0c62a218bfe147ce ]

Add overflow check for Index + Length to prevent integer overflow
when calculating the truncation length. This prevents negative
size parameter being passed to memcpy().

Link: https://github.com/acpica/acpica/commit/d281ec1ac84e
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3760974.R56niFO833@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background author/search finished. A search for `ikaros`/`void0red`
in this tree only turned up unrelated error-path hardening commits
(hwmon, thermal, ACPICA debug checks, etc.) — not the MidOp overflow
fix. That fix exists only on master as `0e2021f49e64b` and is still
missing from `stable/linux-6.18.y` at v6.18.44.

That matches the earlier analysis: the vulnerable code is present, the
one-line patch applies cleanly, and the backport recommendation remains
**YES**.

 drivers/acpi/acpica/exoparg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exoparg3.c b/drivers/acpi/acpica/exoparg3.c
index c8c8c4e49563e..df770f36b4d08 100644
--- a/drivers/acpi/acpica/exoparg3.c
+++ b/drivers/acpi/acpica/exoparg3.c
@@ -152,7 +152,7 @@ acpi_status acpi_ex_opcode_3A_1T_1R(struct acpi_walk_state *walk_state)
 
 		/* Truncate request if larger than the actual String/Buffer */
 
-		else if ((index + length) > operand[0]->string.length) {
+		else if ((index + length) > operand[0]->string.length || (index + length) < index) {	/* Check for overflow */
 			length =
 			    (acpi_size)operand[0]->string.length -
 			    (acpi_size)index;
-- 
2.53.0

