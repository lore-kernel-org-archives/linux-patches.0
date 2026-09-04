Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF984119F9;
	Fri,  4 Sep 2026 05:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499181; cv=none; b=SNuoX7ezvoGNdZIwyXoev9iV7PCrJVf9d1tBT00Dx9KnbUlePaHJwvkx1tSJmWHmuSbpTfrL0cxPTMznvc/1hkU5dS9OLIjOcSQy6Nywft3zpo1Uuy12pCN8Qnq/X4P1dmwUQyMSBpgd4DLYrm/TpRDvvJnTjFkIpuTEp7IIJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499181; c=relaxed/simple;
	bh=qvT2Vg5u1F24vbGlenOpE1N1SNFPoERMsz5Q7caXH5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRYJFoB5Dmv0lQZb/rIUi+HeCZavAJZjubhyZGTd5S08iDbmsusTu8mSrAUw5vQ27dkbhs4Rz7azr0fL2GVWL5b+KJJ6ecFtgkLVNXatbB8L8yKTAHCVy/CBa8J0qNvZSIhfTw7kQO+jBqDEkRpYPGNf3XEdgooOEgBkevjrQvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePjYiJCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePjYiJCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C3B1F00A3D;
	Fri,  4 Sep 2026 05:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499179;
	bh=BX7UNxEVZXHAnL3QIJo/l23nezJ1F+kmVMATQjcJJgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePjYiJCDPTYD2MuAG/d5KzQAQDLGYe3s+Gss+oem1yUpWDmqXfAuyMfHm/fbQ7ZmR
	 CfpkYWow+1pZrOKN1J90kXn4i5e+zeCJXhtJI556uoG7peVNHcQz/TCG6zh60Y5g3a
	 Af+xerKA+3z6wpWR+ttot1zK9t7bYO1GTsnZ/2js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 327/713] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Fri,  4 Sep 2026 06:54:55 +0200
Message-ID: <20260904045811.161310039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Krutskih <devsec@tpz.ru>

commit 73c37fe54cd056d07461b142ab0b8b81e1ef6ad8 upstream.

Reserve space for the termination NUL after the maximum 20 decimal
digits of a long long value to avoid buffer overflow in sprintf().

Fixes: f5db4af466e2 ("dm raid1: add userspace log")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Krutskih <devsec@tpz.ru>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -139,6 +139,7 @@ static int build_constructor_string(stru
 		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
 
 	str_size += 20; /* Max number of chars in a printed u64 number */
+	str_size++; /* For NUL-terminator */
 
 	str = kzalloc(str_size, GFP_KERNEL);
 	if (!str) {


