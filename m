Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047559;
	b=B1lJ8cWBxVSiyhtDkj10mYiOKwFu0KcoIoD/jEmP1kS7Doh9F7lOJtatCKskgeF57Y2f
	 ukZ4D0HC6XQ4S7IXwJ+WpzontRffWPAtaOZoRfj0RU+oMYUHRH4VwRVzZWG1XVh1E7Kdz
	 6lYP5srSnbXH9yJvai+dJFSga8h3ApdK+ON2eVnh40XExClsxkTNNyGNvUX8G5+sXU83o
	 u6I288PMpyGbDaf7s9l91mAy2VKBJtX2xtQLP55+XV4oB7DfpF2Gl1SSVb1ZD497cheio
	 WpEdh2dGzMtp+3QmfDbBk2cSoj0UwqcMmPtkV9Y9F+duhSfS3MVCNk5y9StkYIf5DwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhKu37C93i/jkP5rIS76GWXnwsN/F6GafVfUR8X/OOg=;
	b=lojrp+2NxWZqLm6BApWBAEUfvNQvn3WUzzxtZibvYZCHt9nSs7uFWwSHbXQkpN7i/xW7
	 yLyHJADlN77pE44C8KVkma3iyHCUEzY++1IDKCwSGrXZIy7yXdMf9eODeLfwJHEEuXVMK
	 1hFoLxNDZ/4CZ/qXlYTAjjcC/lTXJ09OvbLYslvPY+NAvaAOY3RuqdcuihzYCRE+7bXaR
	 SzonHk7gmE/DY8EGRXzQY8xfATAR4c2Jm0ZPWWhXhILsBPr/8Vs7S9GlknRBERk1FX0TF
	 a41JSA0JXSO+0UMYVtPXlrBtq2XFxgWyrDBnhVKEWkb1ZbNv7ofIq6u6RpW0mFG9MeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKaIdE5N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23124606A32C;
	Thu, 19 Nov 2026 00:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKaIdE5N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772821F000C4;
	Thu, 19 Nov 2026 00:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047559;
	bh=WhKu37C93i/jkP5rIS76GWXnwsN/F6GafVfUR8X/OOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKaIdE5N7FTsz9dVSa6d14gmSahoeJSAz8WBoOzmlUvIpsFtT6ga4lWgDdtiVnz6q
	 Rz8RQpiQaUfwzU5DW8iVqdmtp0ImgmdDg5U2ibTo8yED+I/VB+/uXYSpm0htFtNDh8
	 DWfpjNBPZJXO2cUEmtEYWhohAHRQZG3yrQEbb3bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Perron <francis@akrites.dev>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1680/2857] apparmor: fix query_data() output overlapping the lookup key
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150301.819854891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit d30844001360a403a511cf24fc75ecaa6a7a7544 ]

In query_data(), buf and query point into the same multi_transaction
buffer: buf at the start, query a few bytes in, and the lookup key
right after the label string that query points to. Reusing the buffer
is by design and is safe as long as the query is fully parsed before
buf is written to, but the key is not: it is dereferenced on every
iteration of label_for_each_confined(), after output has already been
written. So when the label has more than one profile with a data
table, the data of the first matching profile is written to buf while
the key is still needed, and overwrites it if the data is large enough.
The later lookups then run on a corrupted key. Besides, if the data has
no NUL byte from the key's position to the end of the allocation,
strhash() -> strlen() -> jhash() reads past the 4096-byte slab object,
triggering an out-of-bound read:

  BUG: KASAN: slab-out-of-bounds in jhash+0x595/0x5e0
  Read of size 1 at addr ff1100001159d000 by task exploit/155
  CPU: 0 UID: 1000 PID: 155 Comm: exploit Not tainted 7.3.0-rc7 #1
  Call Trace:
   jhash+0x595/0x5e0
   aa_write_access+0x880/0x1400
   vfs_write+0x26f/0xd20
   ksys_write+0x115/0x210

Writing to the .access file is unprivileged (0666), but triggering this
requires loaded profiles that carry a data table, which needs
CAP_MAC_ADMIN and is not the case on default distribution policies.

Fix by copying the key with kstrdup() before writing any output to buf,
so the key stays valid across all loop iterations regardless of what
gets written to the overlapping buffer.

Fixes: 317d9a054e1c ("apparmor: update query interface to support label queries")
Cc: stable@vger.kernel.org # v4.13+
Cc: Francis Perron <francis@akrites.dev>
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
[ sashal: adjusted context for label critical-section helpers without the needput argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 1476517ddef11..c92e9517a02c0 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -743,7 +743,7 @@ static void profile_query_cb(struct aa_profile *profile, struct aa_perms *perms,
 static ssize_t query_data(char *buf, size_t buf_len,
 			  char *query, size_t query_len)
 {
-	char *out;
+	char *out, *keydup;
 	const char *key;
 	struct label_it i;
 	struct aa_label *label, *curr;
@@ -764,11 +764,18 @@ static ssize_t query_data(char *buf, size_t buf_len,
 	if (buf_len < sizeof(bytes) + sizeof(blocks))
 		return -EINVAL; /* not enough space */
 
+	/* buf overlaps query, keep a copy of the key for the later lookups */
+	keydup = kstrdup(key, GFP_KERNEL);
+	if (!keydup)
+		return -ENOMEM;
+
 	curr = begin_current_label_crit_section();
 	label = aa_label_parse(curr, query, GFP_KERNEL, false, false);
 	end_current_label_crit_section(curr);
-	if (IS_ERR(label))
+	if (IS_ERR(label)) {
+		kfree(keydup);
 		return PTR_ERR(label);
+	}
 
 	/* We are going to leave space for two numbers. The first is the total
 	 * number of bytes we are writing after the first number. This is so
@@ -786,13 +793,14 @@ static ssize_t query_data(char *buf, size_t buf_len,
 		if (!profile->data)
 			continue;
 
-		data = rhashtable_lookup_fast(profile->data, &key,
+		data = rhashtable_lookup_fast(profile->data, &keydup,
 					      profile->data->p);
 
 		if (data) {
 			if (out + sizeof(outle32) + data->size > buf +
 			    buf_len) {
 				aa_put_label(label);
+				kfree(keydup);
 				return -EINVAL; /* not enough space */
 			}
 			outle32 = __cpu_to_le32(data->size);
@@ -804,6 +812,7 @@ static ssize_t query_data(char *buf, size_t buf_len,
 		}
 	}
 	aa_put_label(label);
+	kfree(keydup);
 
 	outle32 = __cpu_to_le32(out - buf - sizeof(bytes));
 	memcpy(buf, &outle32, sizeof(outle32));
-- 
2.53.0



