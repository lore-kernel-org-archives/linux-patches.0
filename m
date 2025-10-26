Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC04187332;
	Sun, 26 Oct 2025 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490206; cv=none; b=htP/kiOcPKw1QYJJvYOiICG/3ate907f0ZxY7UofcokjSy1Hlle4lSWSjtSxQyMMyTZn3HIEVYIaJZ72ltOdqo6VILu7ahbTr5JM+o9xZtTUeLvGP7BuP6G08Um04gxC2V8P8EYg/11G+oOQ3KbKSJ0ZtLzsUn9GRWq8fk9CyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490206; c=relaxed/simple;
	bh=Z8kJFUond6dzY1rdtD+TmeCd7rdhB/fctIMUpQUYd98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jAV/q9VtEUGxKdv/aWpunENbvk/b3LPs5ajJgVhHTeoSDAJaiMEtMUlLJ7s5QA/bZcPNYmlYRwKsIVOmOoJ/FQrhoh7/Y/weh/tmrV9HGSdeygNQmcCUhh/ZckcGYAu7qAewODAq3BkLDzQI7RMT9K9KEd5c3zxYUZD3+eAgfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a36W0iYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a36W0iYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B35C4CEFB;
	Sun, 26 Oct 2025 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490205;
	bh=Z8kJFUond6dzY1rdtD+TmeCd7rdhB/fctIMUpQUYd98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a36W0iYhrknSEk6atxmm2/uhQaL1tpzA5QykJJjuH4ShEaaZDt0oan++859SS3GuV
	 Iunkt8b9mBF8DJwTd5M0vvn5EkvbZ3qc0/wTYDd2m4lln4abBIpm4+/bmOdswO7uqE
	 VJYbyjxQwzpl+tn+XaDAjc63+PBlr3YyPRKvoFRTj3ZMDuwcv961qhWsHPt1wHLnSG
	 uqEb2LOz+6p8ajAMBnhqvIILjoCNW7DKhEHZHZ4uNLSWlSiSeW7DJe0pDjANzNkS1t
	 gyBFkD0+Z3JectYR382aeMzpMS4C8/8DNLCEtCSjTT0uA3TEU54Q4usmiiZ/uRYb83
	 TTZiPrFdd7Wkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.10] um: Fix help message for ssl-non-raw
Date: Sun, 26 Oct 2025 10:48:42 -0400
Message-ID: <20251026144958.26750-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 725e9d81868fcedaeef775948e699955b01631ae ]

Add the missing option name in the help message. Additionally,
switch to __uml_help(), because this is a global option rather
than a per-channel option.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

The change simply corrects the user-mode Linux command-line help for the
`ssl-non-raw` option: it adds the missing option name, clarifies the
text, and routes the message through `__uml_help()` so it appears in the
global help instead of per-channel help. No runtime behavior or kernel
interfaces are touched—only help text handling in
`arch/um/drivers/ssl.c` (`ssl_non_raw_setup`). This addresses a user-
facing documentation bug, is trivially low risk, and fits the stable
rules for low-impact fixes improving usability. Next step: consider
picking it into stable so UML users see accurate help output.

 arch/um/drivers/ssl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 277cea3d30eb5..8006a5bd578c2 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -199,4 +199,7 @@ static int ssl_non_raw_setup(char *str)
 	return 1;
 }
 __setup("ssl-non-raw", ssl_non_raw_setup);
-__channel_help(ssl_non_raw_setup, "set serial lines to non-raw mode");
+__uml_help(ssl_non_raw_setup,
+"ssl-non-raw\n"
+"    Set serial lines to non-raw mode.\n\n"
+);
-- 
2.51.0

