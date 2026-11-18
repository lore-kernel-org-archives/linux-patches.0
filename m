Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021040;
	b=YM09HqVuH7Xum0YAUb3S+MBOHYDR7anNO9mAjgT1p+mAGO3Q6aR56+yDgE3XhTSXmG3t
	 WkSCv04aFUgBpr1mbXaOlm0LjFyJoNdJR2E6NUwI+gtV3H1YnA/sNLYI0jDiEkJh9NlS/
	 KLAqPbQVJ9xqNvKzRrl2Iyw52+4da8ObaXEWnuRzxWpkyOhI9rIw3gTqpZ8Iqaaj2sr3m
	 br8rMSwWhB3pOA9JUcKbZsuo42/o3f2WTNf//Inp/BAK63pX3LMXNzFF3f3UdW0uXhs4E
	 vFzZd0mdzDgMrJ17ZODueLD1tI1stVb0gPvtc1HhXtiltrYDX8Zi6dPWhvOGKzMF1hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4jn9Du1r43RlM+wNdDc5jBD4fvPuxZnRCbyUl9ssrs=;
	b=KAbWwnFWDjWy81Esqaiz1fRYQym4PPnF41PhWK/AcmG44WZ3LsMCXbuFbrNs17ZjC9eZ
	 zCb2+ruJM1O5djuqXObFdWKO/kaRQ2P1wQVVjprdOuya/UJuLym90eZchg/ZdJp22GwEr
	 Q08/1+wKxrh4lFGYODTgTHBRhGAQlB/7Zq+rQHMlA7HxHwmrJATCsA8zyDOEY7MUmKC3H
	 yLaZGc3VJrs12vyf2NhjfdvSTjLGvV/rYV+sTZCCDtFnzo0g823q4gqzguRUEXC2BDal7
	 0NBZtnrNCUMNGyGEQcoWVYrJ5C+zaGfOnObm85T45YKwdYuTcLCnMgdUyBioo4tbsRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNG3pAuI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D546D606A32A;
	Wed, 18 Nov 2026 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNG3pAuI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391091F000C4;
	Wed, 18 Nov 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021040;
	bh=s4jn9Du1r43RlM+wNdDc5jBD4fvPuxZnRCbyUl9ssrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNG3pAuII97dRJqhGJGuKiQ8mVg+nj5ToSLWWEutUxz+YFhNC0KM3FGLlcl0bBdc4
	 zWOlY7JmtNTChA+990bZ8Dltm+9yFTFNp5m+IsaUheLt6/m/nni5i8w3L91TPZb1yF
	 f5nZ+2Lk9XyZvxInL0ym1XnQiFYIxQ+x4ueTNIJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2166/2651] tools/power turbostat: pmt: Improve sscanf() hygiene
Date: Wed, 18 Nov 2026 15:56:46 +0100
Message-ID: <20261118150403.796687670@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit e817a533bbc0aef5a9cb6255153941ed968d2fb1 ]

Explicitly check sscanf() return values for number of matches,
and handle EOF (-1).

Defensive programming -- not an issue actively seen by users.

Fixes: 4265a86582ea ("tools/power turbostat: Add PMT directory iterator helper")
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index cb3d571f121ee..7e6e84d3d9c63 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1995,15 +1995,17 @@ int pmt_telemdir_filter(const struct dirent *e)
 {
 	unsigned int dummy;
 
-	return sscanf(e->d_name, "telem%u", &dummy);
+	return (sscanf(e->d_name, "telem%u", &dummy) == 1);
 }
 
 int pmt_telemdir_sort(const struct dirent **a, const struct dirent **b)
 {
 	unsigned int aidx = 0, bidx = 0;
 
-	sscanf((*a)->d_name, "telem%u", &aidx);
-	sscanf((*b)->d_name, "telem%u", &bidx);
+	if (sscanf((*a)->d_name, "telem%u", &aidx) != 1)
+		aidx = 0;
+	if (sscanf((*b)->d_name, "telem%u", &bidx) != 1)
+		bidx = 0;
 
 	return (aidx > bidx) ? 1 : (aidx < bidx) ? -1 : 0;
 }
-- 
2.53.0



