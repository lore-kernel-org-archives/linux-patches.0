Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1C749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E5FC433EF;
	Thu, 12 Jan 2023 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532339;
	bh=8XLsc6266s58bkh9POzdd57ls3/YBr6zksaR4M0NQg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXEP0lVyTNDxQDLptxZkL4fmdo/02uYc1ln5jaZNxtiS6oyAHRAyZ6Ej/YPzgB8wl
	 +Gv02VNdkIzH1Z1DrDRbS///G9fCnTCvKZOWs5jmGBWhhxV7Hx3snXGogVGa2dYFJg
	 H2/z/VNp3J4kl1iLzCdAuVlgp7XRnRBbkZ0ytiJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/783] ima: Fix fall-through warnings for Clang
Date: Thu, 12 Jan 2023 14:47:25 +0100
Message-Id: <20230112135530.280557827@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 28073eb09c5aa29e879490edb88cfd3e7073821e ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: c7423dbdbc9e ("ima: Handle -ESTALE returned by ima_filter_rule_match()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c   | 1 +
 security/integrity/ima/ima_policy.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2d1af8899cab..600b97677085 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -743,6 +743,7 @@ int ima_load_data(enum kernel_load_data_id id, bool contents)
 			pr_err("impossible to appraise a module without a file descriptor. sig_enforce kernel parameter might help\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 18569adcb4fe..4c937ff2e4dd 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -566,6 +566,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
 						   Audit_equal,
 						   rule->lsm[i].rule);
+			break;
 		default:
 			break;
 		}
@@ -802,6 +803,7 @@ void __init ima_init_policy(void)
 		add_rules(default_measurement_rules,
 			  ARRAY_SIZE(default_measurement_rules),
 			  IMA_DEFAULT_POLICY);
+		break;
 	default:
 		break;
 	}
-- 
2.35.1



