Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042712;
	b=taOiO8tJaBl5TZ9WsIoDBhvTZH2+ftm1FqtihEJw7l/YMPOnINCEAt5ycQLfNp5ZPqhF
	 g6Wf1F2rvddGZ35c/h5uIdga5wVMWBFc1QO9PoP6rrBslbz+CbsILM2XIj1pUKzTQOPLH
	 /ZWTAEsgwZ5aOUKIFu0Q0JGGbnDNx15H8NrCYupFuDikJobJl0MUAgfxO5tSpdnJiy3Hx
	 Mx8RaGkrX8JplTeAO5KVSaGxvuZzns3VbBW1CvhlZI+mavQqp3xFVA1r8jBioZa8N9Tej
	 guW7d6h7PuUATcLArHzx5F45dSHbr4Me9A7k53Vy6XTnXvSeM+efqmu+10k73FSDlXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9ruoWT+AnEVpQvX2K0pNnAs6PhOVMFjpHdAxUxQEDLo=;
	b=IC0mDiMpo85wFkwYtci89eP+gl5FwkkOvaixFHEuqDdH69BpMycVHyKf8znWkyBoyLxg
	 z6xpLILXUyOFQzLuUC+tG76gexDPVX1DYJrqYxbXYatShvgUC3KUO20KfVmCixvhHsidJ
	 cMgrTyLHwu9an547j42gJGS/MkkfK/ZicM+AhzkxoDi9VEorjoki7ztMj8DDnEwf/A1fF
	 TKtgRs+OSGCa/PqUIIqnYZrP0y32Up7jbpCElPLoRlVtrq+D89ysDHyleW3sVN+Ama4K8
	 OF2qnpfY4orDkA8idSqPYX5RQqGUt7KEp8l0jtQMT857jRhn1iGb0JyDoRN2FrYaBsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmG2O4Rb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC183606A31C;
	Wed, 18 Nov 2026 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QmG2O4Rb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A31F000C4;
	Wed, 18 Nov 2026 22:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042712;
	bh=9ruoWT+AnEVpQvX2K0pNnAs6PhOVMFjpHdAxUxQEDLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmG2O4RbEqVNp3V4cCXdsYyOFqnSqIjextvfU7xtd87LGx/ALHDyyhBq6oiEqC4YJ
	 O6XlV/92iZVHMqPT6ln30X6YAgnCgLboUckPDeEKsCLo+/K15v52EIAufMkSvlubTn
	 SNupO4UtePfwcAAtpOtFD1mhLky+bQro0K9gFYek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3268/3318] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:04:50 +0100
Message-ID: <20261118150457.654966392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 07aee062c6ecaa7199be583c83a1c74ae9885f03 ]

aa_label_strn_parse() returns -ENOENT for every failure, so a caller
cannot tell "no such profile" from "could not allocate a label".

Report an allocation failure as -ENOMEM.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 3d3c55906bf9a..04caba9cbbe26 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1945,12 +1945,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
 		goto out;
 	}
 
-	if (create)
+	if (create) {
 		label = aa_vec_find_or_create_label(vec, len, gfp);
-	else
+		if (!label) {
+			/* not absence: creating only fails on allocation */
+			label = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+	} else {
 		label = vec_find(vec, len);
-	if (!label)
-		goto fail;
+		if (!label)
+			goto fail;
+	}
 
 out:
 	/* use adjusted len from after vec_unique, not original */
-- 
2.53.0



