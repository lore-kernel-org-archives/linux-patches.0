Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C333290B;
	Wed,  3 Dec 2025 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777604; cv=none; b=QLIsJjNHN4NsTScRUKmDGmVg9H8YrHCy3T5Hbiyco9eUBBHS5ow5UPenlsU4JezfZ4wgngI5Imga4UxaD6SgJA6HObBhEXEkLmrbWopbbzAb8PrSMcN5K5Xz4DZlGaWfTIGNYFGdj9xu06GwZ6O3JabMl0XQrwyU2aJmj6Evfsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777604; c=relaxed/simple;
	bh=bVtIn84pceT1PG1uXCndLgM1Isu824vh8/yTS0dQyyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8PWs1ARLdOMWpKjNk2MQgZ9oxClGXqy4wVqISNJj5dggoMdRSEfu/1ekyvFfe/qVDFkyB21WpE5B8ITdVR09sodnjJ+vfF5O8Gge2mL36mbpQsCmYJSjvleeEHuxgx+ePMBLq2JOHU5fy0/CmI0XsAS7nAE7r6KgDJoJUPlQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgM0wpm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgM0wpm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE71C116B1;
	Wed,  3 Dec 2025 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777604;
	bh=bVtIn84pceT1PG1uXCndLgM1Isu824vh8/yTS0dQyyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgM0wpm+ycmuCTBe9tbEaL6E+x3K9wt7U3gRqPsoVUkHy7WMD1juqwoPyADABbXVx
	 JlzRnGG3Ub4WRBBhtVpi3dQc0FG4TxAEizxcd17sDloyc+dddOyvudirNUkSN65XiL
	 nSoF615nNu3ausO9lGa0/w7BG5UcvQcp4S7W+2j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/392] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Wed,  3 Dec 2025 16:23:32 +0100
Message-ID: <20251203152416.393893264@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 98857d111c53954aa038fcbc4cf48873e4240f7c ]

Commit e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level
APIs") redefined the way that bpf_prog_detach2() returns. Therefore, adapt
the usage in test_lirc_mode2_user.c.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-v1-1-c7811cd8b98c@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lirc_mode2_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_user.c b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
index fb5fd6841ef39..d63878bc2d5f9 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -73,7 +73,7 @@ int main(int argc, char **argv)
 
 	/* Let's try detach it before it was ever attached */
 	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
-	if (ret != -1 || errno != ENOENT) {
+	if (ret != -ENOENT) {
 		printf("bpf_prog_detach2 not attached should fail: %m\n");
 		return 1;
 	}
-- 
2.51.0



