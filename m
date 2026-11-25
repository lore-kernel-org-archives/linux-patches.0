Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620276;
	b=Wi2OvbMBwLcKm6KWy01PWsE8YV9oHgu7Bioykz1Id2EjqzVVEkXiCbn6TCZJOSlxsJ20
	 3iJNxEPGreft996Fi6Z+hQRTsKH32AK7JcQL+yk9PEOZ5KEOuiE2hTM3S5lZm5GdWfH5M
	 5P7C7OSv1eazTjpM7MdKe5L06LVY0ZTTAooqcryKKXQn8g7fxP1tlfMvzPTzXlR+QqsRy
	 ecmHZfM+XyeRxEa26kCT+E1l/7PK5wp9PDFZGLMdVvxx3oeAX9UscgaltuNnffUCYL92N
	 u5fO+BCgMuKF+PG14tw4BKqp1TkumPS+JfKVmpSGvHJx/lRYGW7Yr1kifWa+hLabIVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BouRQ5pBIhaVdNgRC85c/0HbahGoFqREtbcTiOuJm0o=;
	b=a2kNotgIvLs9kAH7/zxLDUais5eCBkBJ0eyTdQ+ntO1BC7tSPdsniC+4ygysICmrhIpR
	 l0NeyEokjnNzCoc8imeR4m/AuWAhk008AxbdAjV7o9uB9QEX5+LY+pTAuKGBGNQpyLVwY
	 zXsdl1l2zl+C/DnrG1qvY8gPK9F818V8I5k/M9UWJd8vAy3/B2B8yPi02pf3Tec+WOmmD
	 k1f27jpb1Rpp1UioGq8Np9pF5QOcX67peioZ0SuiKHcRD8hNfptb92puUlfzi44ZL/o3O
	 rBK0R/iDHjCTFdkqKp8jiztQDMulRKPFnI+4kPrjo5A87joqirnvmIjey8AO11S5IZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/RUwpTO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669C9606A326;
	Wed, 25 Nov 2026 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/RUwpTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9808E1F00AD4;
	Wed, 25 Nov 2026 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620276;
	bh=BouRQ5pBIhaVdNgRC85c/0HbahGoFqREtbcTiOuJm0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/RUwpTOYpkdXD135gF8jMdD2TkevJob4sq++eV5UClMWMER32sUNpjTV7KQgIzPn
	 Q4neJIpv00ano6erS0NVF3R3cQytqhVmPVnh1q67kYfqfMtQwHwePD1aaHKEQ6g5LP
	 KkVb8nh2T7rczvlOndyZp68kEibKcPtHdxWw8MiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 7.3 0865/1005] dm-sysfs: fix misbehavior if kobject_init_and_add fails
Date: Wed, 25 Nov 2026 15:36:43 +0100
Message-ID: <20261125143841.971317076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 406d576cc457203cf86eac7f17839b2efec81db4 upstream.

If kobject_init_and_add fails, we must call kobject_put (see the comment
at kobject_init_and_add).

Before calling kobject_init_and_add, we must zero the kobject (see
https://lwn.net/Articles/52085/). If the first call to dm_sysfs_init
failed, it may be called again, and that second call would see an
uninitialized kobject.

Cc: stable@vger.kernel.org
Fixes: 784aae735d9b ("dm: add name and uuid to sysfs")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-sysfs.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -128,9 +128,20 @@ static const struct kobj_type dm_ktype =
  */
 int dm_sysfs_init(struct mapped_device *md)
 {
-	return kobject_init_and_add(dm_kobject(md), &dm_ktype,
-				    &disk_to_dev(dm_disk(md))->kobj,
-				    "%s", "dm");
+	struct kobject *kobj = dm_kobject(md);
+	int r;
+
+	/* The kobject must be zeroed before calling kobject_init */
+	memset(kobj, 0, sizeof(struct kobject));
+	r = kobject_init_and_add(kobj, &dm_ktype,
+				 &disk_to_dev(dm_disk(md))->kobj,
+				 "%s", "dm");
+	if (unlikely(r)) {
+		/* Weird semantics - we must call kobject_put on failure */
+		dm_sysfs_exit(md);
+		return r;
+	}
+	return 0;
 }
 
 /*


