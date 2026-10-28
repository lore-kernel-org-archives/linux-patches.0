Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212487;
	b=p/FDIDWfsqwA3CCCTI7cOLfZg/45U2Xx76lLN6UODsiiXOYxqmwgzlh8WOzGmR3NSs2I
	 lEBsuivY1pCt9s1kl3OwkpW1PJpBp8Q+QSLFJNQJTSQ/y+Vn+4WBb5bp8SG/XPwg0+6NY
	 Kd4gcGOqXn3TZykT5NdiO+MKTQqndbYSnKAx0NSwn4ERh9M0NxOJsl+Crqz1VhT3iflz2
	 2zA3VL4HJSUuoY5s7tX4ZGXamPElxAZ2bEAlmqZq74e+mB5BUnQgII/nuWQp7sbz02DWw
	 DaQ9duT4H9MxxWOCCTQNDBHIKB6067nLG8/x/0fXTQGXxM3mYtpe+LuMVj6QTMqtzcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xkeJHEyYW2hnNpAPBDbdZBOf/oqAcmsenV+BbRRZ5lY=;
	b=w8F3q2VZu5MsSt2KVFvYw/RAbNvAMa2X6QTQ0ruT63Pt967wBouXvhcWntb/oeW/p/lG
	 FzJ4/sZrFQOmgYOfu/5UPYLjwIamr3eRzlAx7KFT33xEydwHetIE3Vb83TtcUwZ5SqLmG
	 txLigQws79FFoiwaKXi2h69ixpVZITYkTr7Vf923e3ny+EGGUaGjIe5BttGPTdDiYo7IP
	 zQ/ZW2Td6NLxTVwiqhGAVva8AA/l49TLcA8hRfRRZpxakN6YhIX+Jm+zUxrG+3ogkFm1n
	 /F/MtxZXwx/S20wy4PUSqMZEUxpY2aARtmu3vzZGNzfEKXa/NkiAdWzWiJo4p7klaEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OehQuzKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E1606A31C;
	Wed, 28 Oct 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OehQuzKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C21F01825;
	Wed, 28 Oct 2026 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212487;
	bh=xkeJHEyYW2hnNpAPBDbdZBOf/oqAcmsenV+BbRRZ5lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OehQuzKm1S7nip5htIwPjSbNqKu6UNzfMQK6QStQEU7Wk/ACq551vzV9h2d1EecT+
	 3UE7mEI2JdIDWHRVyCEQWK5WFdliFssfo6wAa1f0B2d+KigfyDdFySnat1YOnuMRhX
	 QsEvpXzFcAn+rwtP175i1fkCI7gOX2zWW3EuBq+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Bradley Morgan <brads@mainlining.org>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 0172/1887] audit: fix exe mark UAF in kill_rules()
Date: Wed, 28 Oct 2026 17:37:48 +0100
Message-ID: <20261028170503.153625442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit aa650d87a498844060eecb1d336f4d46f4d1b0b3 upstream.

kill_rules() removes mixed AUDIT_DIR and AUDIT_EXE rules when an audit
tree is pruned. It drops entry->rule.exe before removing the rule from
the RCU-visible filter lists.

After a rule has been installed with AUDIT_ADD_RULE, which requires
CAP_AUDIT_CONTROL, removing the watched directory can race with another
task that is still evaluating the rule. In that case, fsnotify can free
the executable mark before the reader reaches audit_mark_compare(),
causing a use-after-free.

KASAN reports:

    BUG: KASAN: slab-use-after-free in audit_mark_compare+0x8d/0xa0

Unlink the published rules from the RCU-visible lists and retain them
on tree->rules for cleanup. If any rule has an executable mark, wait for
a single RCU grace period before removing the marks and scheduling the
entries for freeing. Otherwise, call_rcu() already provides the required
deferred freeing without a synchronous wait.

Cc: stable@vger.kernel.org
Fixes: 34d99af52ad4 ("audit: implement audit by executable")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
Tested-by: Ricardo Robaina <rrobaina@redhat.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_tree.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -543,22 +543,38 @@ static void kill_rules(struct audit_cont
 {
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
+	bool need_sync = false;
 
 	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
 		entry = container_of(rule, struct audit_entry, rule);
 
-		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
 			audit_tree_log_remove_rule(context, rule);
-			if (entry->rule.exe)
-				audit_remove_mark(entry->rule.exe);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
-			call_rcu(&entry->rcu, audit_free_rule_rcu);
+			if (entry->rule.exe)
+				need_sync = true;
+		} else {
+			list_del_init(&rule->rlist);
 		}
 	}
+
+	if (list_empty(&tree->rules))
+		return;
+
+	if (need_sync)
+		synchronize_rcu();
+
+	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
+		entry = container_of(rule, struct audit_entry, rule);
+
+		list_del_init(&rule->rlist);
+		if (entry->rule.exe)
+			audit_remove_mark(entry->rule.exe);
+		call_rcu(&entry->rcu, audit_free_rule_rcu);
+	}
 }
 
 /*


