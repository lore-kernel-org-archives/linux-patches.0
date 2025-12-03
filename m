Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43535A936;
	Wed,  3 Dec 2025 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778911; cv=none; b=Ocz/HeRO/LbBdohZUtdsZXGaJ7kqu9xtcN/AV+bro22byhpXM2UGfNuumtLJnztNyP2svrbPdnjGrcc5XBqODCO/oD6JqVj4O8q5YdSdWPn9eL002RsGEogHQa9Xse8gXFgI1i35EqtrZrhoQq612hG2lrVJcw/pP6d2cypO9tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778911; c=relaxed/simple;
	bh=J70TTEiKF9c8C7OfF8ShswOOmjOxIxQHUL5ODBHflOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dfJ87wxT/mlGnG1Z//OpVGtaqozV/7L0xVDAvjNsQ8Bukl9dC5uGhRCQO1XWJja1jzZHdD5g22P8IvRtuIIKIgx780zk0PkYOElzxo3B97hEkuQBj6l3IC//xQPG1dd0a/ZpSjy2hts7ei0kacLo/p7/PulmAosI/KLL/o2DUjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg1grwsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg1grwsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D96C4CEF5;
	Wed,  3 Dec 2025 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778911;
	bh=J70TTEiKF9c8C7OfF8ShswOOmjOxIxQHUL5ODBHflOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg1grwsKpXbo83F8TdOrQMAzDdtUFyNBbxFaff4Keg6YkWEm7iOs+Zh1FF0tDESlH
	 lPbyScSBbJ93UKlDX/guaSkMU9aQ2orRfouRSPGozbHVXE3RmvRDzJXWTBoavnd+yp
	 AzgVoyh/2Ut+fyMEeD6da9oLFL+5439WksJFimTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/568] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Wed,  3 Dec 2025 16:21:38 +0100
Message-ID: <20251203152444.255794937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



