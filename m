Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB93FAE11;
	Tue, 21 Jul 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659832; cv=none; b=pwCbcQa+LHwoCW7vdC7qXYpr4r/j/IatsSiUyoWlmxVM/0Wx0ylj9I42oNlS4lx2/9R1seO9f7UOn7XMQqsc4Eq5rGkDlDCzn7tRiz3ulVgXI+nicstDXdN4ariPuYuKZxf7fqVl3vhV31RSdqBlnYP/IDObn/hlzCMZd0TANc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659832; c=relaxed/simple;
	bh=7e0baEUKhyquWNJNvwC0v8pPGed943DknobteyR0Pf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdMnzv1/XIB+KoygDUvq4xLjOphMJYHRyrjNXsRe/z5hozyCfam3ogJBYfpF6h2xuHS9qjFgOfsHS9rWCVloNaqfjas1S1G6CUGlSM5b5xIP9t8jMeKyyUFBHkltz4uF+gr4ALbZv8iHqPzXik7SB+gShQg37jBD6QZ4Rd2OnA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mlnx4umY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mlnx4umY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14901F000E9;
	Tue, 21 Jul 2026 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659831;
	bh=QT/FXS+lobSGA5c5DVujZs4TWF6RLDsUu86Gb02AcGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mlnx4umYJWxVF/FAtlZiblDRyYlmYKxDuskBPgDbRnD4OCmBXAmKAd9d5tVCOKV6h
	 LHU8zJ5T5ju9GghxSRyTEx+5oWKEX4TBSMzN6d+dsnFez0rOKzYVLOIkX5kgUMV5Sw
	 UXCKEkq+UBLzS95IT5QC6mXc3yoFS6FiphTV1VMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0751/2077] net/sched: sch_dualpi2: Add missing module alias
Date: Tue, 21 Jul 2026 17:07:04 +0200
Message-ID: <20260721152610.504931377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit ee1ba0add3fbd5a28fa5423be373acd147f1e344 ]

When a qdisc is added by name, the kernel tries to autoload its module
via request_qdisc_module(), which calls:

request_module(NET_SCH_ALIAS_PREFIX "%s", name);

i.e. it asks modprobe to resolve the "net-sch-<kind>" alias (e.g.
"net-sch-dualpi2") rather than the module's file name. Since dualpi2
was shipped without this alias, the autoload fails:

tc qdisc add dev lo root handle 1: dualpi2
Error: Specified qdisc kind is unknown.

Fix this by adding the missing alias so the qdisc is autoloaded on demand
like the others.

Fixes: 320d031ad6e4 ("sched: Struct definition and parsing of dualpi2 qdisc")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://patch.msgid.link/20260611205849.3287640-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 592c58938d3e80..5434df6ca8efe6 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -1210,6 +1210,7 @@ static struct Qdisc_ops dualpi2_qdisc_ops __read_mostly = {
 	.dump_stats	= dualpi2_dump_stats,
 	.owner		= THIS_MODULE,
 };
+MODULE_ALIAS_NET_SCH("dualpi2");
 
 static int __init dualpi2_module_init(void)
 {
-- 
2.53.0



