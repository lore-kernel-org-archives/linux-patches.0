Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774241;
	b=bzx3ko5YVm3UYIx2KddvxerQMzlskt/cuYfrxP6aznCeaNfosQ9meLFmUKqwpqWP8H3d
	 EIZf1EUEA+h3KpO7sCWHon7cgtOwYIdW2F45NzJNK5raIgT7V95tGCqMdJ4vkq8Z/ZGDK
	 vkbjxloCAOcoOxbxVPGnVici5UxxwDup7OwmGUkbOu+oBhTy9W4EFoxRphwYsOWlZJvk/
	 /3lDe8L0zWZlNUcLqE9xctfcjaENQmu14pKHlgNOGSK9uBtylByp1r0g6dZoof/02jdVZ
	 D/knJq5G8k8p7gYGmEOI2rWmLoWKn514UiSVB4o4YFLG+tDyj6/ydeiILpS98uMuIBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+GwTW2wX0yp23lNEUVIELkuFPJUcppTFYKbgweIyCB0=;
	b=n5hP+b4L03SMEXkxOFJ8QHz51Tp4c9J8NOyHZnkgNatJJdy3l25YqQGTfiebDl4urKUo
	 gKYuCdKtUst0LOyNF1XVwHeeT+z1KPuyFa34oelKQDC1a8fJr1A48LrrE13bOIZenypQQ
	 oaTeuZo4D+PXvZaWOkWUL2+lszkgaAMvIOR2Lh4uJe9FKT+lxpWW8uM/putOCbBp8gcEH
	 FJrRWMGKoye0ACigpwOud71bZXkPyg4QHLcI1SNvyU1PbjqAHKLDux7/aOqSOwypz8TTj
	 oABPSNvPiSxP2ycvk8JDmWAYVPEXXNWqfEDGziY6g1buqig0hfObRjMDnhCtHe65Q/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vb3ZGm13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84C0606A31B;
	Fri, 23 Oct 2026 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vb3ZGm13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D911F01825;
	Fri, 23 Oct 2026 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774240;
	bh=+GwTW2wX0yp23lNEUVIELkuFPJUcppTFYKbgweIyCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb3ZGm13kclO6HmEOyhWCYjyaGs/4WB4/ZkgrVY3pAIiysPoFpeSZdtCvMR3C0vHi
	 SmtPSMoVPXkfkV7HCdEScbYDw6BBf+PYP466rOc11/WhgEOK6/eP74hY5Xcnfu1Oh4
	 mLsJGR5Y+JM2Ce+7hMVpSyo+U9zmnRH3AHBSi5QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/193] tracing: Fix ignored return value of resize_buffer_duplicate_size()
Date: Fri, 23 Oct 2026 18:37:24 +0200
Message-ID: <20261023163718.161771748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 3110d09bb98e3ac66482a7b257548a1683ec6c1a ]

When tr->allocated_snapshot is true, resize_buffer_duplicate_size() is
called to update the snapshot buffer size. However, its return value was
not checked. In case of a failed resize this could lead next snapshot
being incomplete.

Add resize_buffer_duplicate_size() result check and return error if
resize fails.

Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928152634.4354-1-d.kandybka@gmail.com
Fixes: 180e4e390978 ("tracing: Add snapshot refcount")
Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: Adapted snapshot_buffer access to max_buffer in the existing snapshot handler. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7811,9 +7811,12 @@ tracing_snapshot_write(struct file *filp
 		if (iter->cpu_file != RING_BUFFER_ALL_CPUS)
 			return -EINVAL;
 #endif
-		if (tr->allocated_snapshot)
+		if (tr->allocated_snapshot) {
 			ret = resize_buffer_duplicate_size(&tr->max_buffer,
 					&tr->array_buffer, iter->cpu_file);
+			if (ret < 0)
+				return ret;
+		}
 
 		ret = tracing_arm_snapshot_locked(tr);
 		if (ret)


