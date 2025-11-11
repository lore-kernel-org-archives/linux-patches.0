Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6134C97;
	Tue, 11 Nov 2025 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822571; cv=none; b=rmD8oRHQ6SMEEFhMT91PWh/FwO7uhwmrvX9GwcYW4Httzrx0SKHlTkVaH+TU9TNQcEHqm7O2mFUqIkhNa1F2U7I14QUshdQDnnVN4UBxivvDeVtWw9SwrQo0nrnw+GYJAxp31wc9bI25rx82noe0zLoJOFShIS9x5eqsZ/IGDxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822571; c=relaxed/simple;
	bh=Q4SIXdj4QSuh+hJrtzqHwKsgdew657vHylqGw4mi8Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQ/XsYIHOb2bD0LNyNx2mFtFhCOJn10x9Fm4cL1A1CgtlCAqa+4K/uunW5LsO7ceK9u+JwezqQ5sYJuEOGZSMrGf0s+kusDzmNF+OoXuV19F+kKd5n+igFTEQVujFBLzj0LlSparQRGoF3wn9DkLfy9S6LsBMDs2daZRpSW6B20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgP9bJ7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgP9bJ7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF19C19425;
	Tue, 11 Nov 2025 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822571;
	bh=Q4SIXdj4QSuh+hJrtzqHwKsgdew657vHylqGw4mi8Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgP9bJ7RSrMAf998HfYyZ8S3mtME9AWrDxjqyg7i+HlhkoWx0gzfPR8x1uCIPhUhk
	 Kp2i1WQ1Ojf/mULXUUVzWRY1YIlAuxR6km8HQRL+t3f6cPTMcLnfFgQDXBkdvxXepT
	 iqYMt8ByOZbrHqwJfU8ln2ghgiLDKD2nTlgpW+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 139/849] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Tue, 11 Nov 2025 09:35:09 +0900
Message-ID: <20251111004539.756199226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4694422aa76c3..88e4aeab21b7b 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -74,7 +74,7 @@ int main(int argc, char **argv)
 
 	/* Let's try detach it before it was ever attached */
 	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
-	if (ret != -1 || errno != ENOENT) {
+	if (ret != -ENOENT) {
 		printf("bpf_prog_detach2 not attached should fail: %m\n");
 		return 1;
 	}
-- 
2.51.0



