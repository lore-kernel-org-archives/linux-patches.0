Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015535;
	b=Yd23QqSxZkPZi9u9Q2dsxCnz8cpSfJWWKKqeHD8XUgtxEmWN/+OQOkGhQkiT0Gtf4HKk
	 rKQSWLILaFKAwKQ12bEzgBbpk9cIfsuI9bcHXneFfIUKIqLWl6VlkIxciGGCKJRfxPX6f
	 H+MEMccRxvnYKImwrwlYgb+LuLC0Jr6CD/VurN/wKK6c0Mqae3XKguGINZaWg5cWyBLj0
	 U1eB0Moc3UQI8cDwg8bf6RKYK+ltvQ0mtNR3TJRwxxsbfGnWYpWXo8FXAT5u+5DxhsKnz
	 jNtC92MGZZtvfMupbMzNP22W6RI0YnVmz6qW/+q7SXPDIKsk2iErpQyE7S8Oej59Htg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LOuonjO7Ui+SB1kJ5ssEsFQX+Io59peI2punyDwP6Zk=;
	b=sBYIdXzlcuYi+X/5poYjCX/eE4OgFQqpm1DPqUeGVt+0J+Lcbuh3Ju2D+oB0GGvRRK/z
	 6zTTZ6r/DdtD9kRrbPsuZONVT1B51RamS/rWRLGBwBAEN+TMElbyvWbnskAcEuZBqk6vk
	 9y1GiKnNEN639CKurG4NrVtrHgIGKIS78mvRSjm0/qIa3nbWnCYyXz+qjQY1rrBH16FQC
	 BstxZIOJMeK+TDOG3Z1UjAboUeox9AuT/0NHoBCeGprP3KAOdmWsCVGo7L85dIUrWaHKZ
	 SX+L1QIlQ85Ih7vI6IFiOT+V+RhfzZWzypOsddT2EGj+uLIHMF0q1mxSZvQSMBY2guQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0f9n09Wk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0FF606A32A;
	Wed, 18 Nov 2026 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0f9n09Wk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C3A1F000C5;
	Wed, 18 Nov 2026 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015535;
	bh=LOuonjO7Ui+SB1kJ5ssEsFQX+Io59peI2punyDwP6Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0f9n09WkHA8+hqZ3L+/hnRuYsMGhBAxPVfsDC3TgFljlENHQDKjE7bLtv0Moabfr8
	 90rnL6Q4s1Ulbgj9kmS/+WCnROOtXcCvQPo+uFW4nOhVs1u/AzRoMZrbnfcu4gs0/e
	 3mPN1RTkmZtpzdxG61AQXjQVRvR9a4FB5NuFrzP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0167/2651] dlm: fix NULL pointer dereference in dlm_dump_rsb_name()
Date: Wed, 18 Nov 2026 15:23:27 +0100
Message-ID: <20261118150253.861261113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 19982c99a302ab544c69f95d37ca3070c89762d3 ]

The function dlm_dump_rsb_name() is called from receive_rcom_lookup()
when a debug dump is requested via a special RCOM_LOOKUP message with
rc_id == 0xFFFFFFFF.

The resource name passed to dlm_dump_rsb_name() comes from the received
message. There is no guarantee that an RSB with this name exists in the
local hash table.

dlm_search_rsb_tree() returns 0 when the RSB is found and stores a valid
pointer in r. When the lookup fails, it returns -EBADR and leaves r
NULL.

The current error handling is inverted:

    if (!error)
            goto out;

As a result, dlm_dump_rsb() is called only when the lookup fails and r
is NULL, resulting in a NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2d90354027ad ("dlm: merge toss and keep hash table lists into one list")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 3be1d6007e359..9aa4f7a190742 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1421,7 +1421,7 @@ void dlm_dump_rsb_name(struct dlm_ls *ls, const char *name, int len)
 
 	rcu_read_lock();
 	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error)
+	if (error)
 		goto out;
 
 	dlm_dump_rsb(r);
-- 
2.53.0



