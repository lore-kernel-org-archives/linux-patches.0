Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D031A38D4;
	Thu,  6 Jun 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683224; cv=none; b=HcXTsZBh21seXkAZZmYi0sIpM42+a7qp9sgSIMCRbC0TvEW/wOpzqIbfwOv6wvcTc2jEPyFC3cJ7lxzx08FKLkJz3dWv+z3Ug4fmcDeFHce0xkIgYk1AxlgGwgjolVGpvdrLpK/F2shrtdoGskrskasDG3m/dq2UaL5Xyi92MqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683224; c=relaxed/simple;
	bh=fYWMlKdlaEFcnaByDjuZD8D2GXIhY7IFYKlS+Vcm+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0gmKXHeAvIGv3fpJRNVogMJOAbVy/oCCu3pyNHJJupoTYB9cxlXimUxJPdvhkF/XA9ihklLf9/Lsb7n2WwjyeyHD0TIcpuq1g3/O1hZZer6uWgoRCEdcoWmJYKHpuFmi+YqoyNbjhfP1nAgXBeswWGz/J4qVV344CWJLWiNV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOqNnqsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOqNnqsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F61FC2BD10;
	Thu,  6 Jun 2024 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683224;
	bh=fYWMlKdlaEFcnaByDjuZD8D2GXIhY7IFYKlS+Vcm+hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOqNnqsF18EwmFmPf1rY8obJik4hxa1rZH8sDuXKIDOhPhldI5XBb9P0+Sl4akA/6
	 MWPgxgNYlX1W6vIg6ZU6NxrWeaFW5ICBBv3jKMc5h9PnqXabBkBWhWGodU34ahNE9O
	 btfv8Oaz5LfLjcc5IDguAfpyL16HtTCNB9OVX0ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/744] selftests/bpf: Fix umount cgroup2 error in test_sockmap
Date: Thu,  6 Jun 2024 15:57:18 +0200
Message-ID: <20240606131737.749677318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit d75142dbeb2bd1587b9cc19f841578f541275a64 ]

This patch fixes the following "umount cgroup2" error in test_sockmap.c:

 (cgroup_helpers.c:353: errno: Device or resource busy) umount cgroup2

Cgroup fd cg_fd should be closed before cleanup_cgroup_environment().

Fixes: 13a5f3ffd202 ("bpf: Selftests, sockmap test prog run without setting cgroup")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/0399983bde729708773416b8488bac2cd5e022b8.1712639568.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 024a0faafb3be..43612de44fbf5 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -2104,9 +2104,9 @@ int main(int argc, char **argv)
 		free(options.whitelist);
 	if (options.blacklist)
 		free(options.blacklist);
+	close(cg_fd);
 	if (cg_created)
 		cleanup_cgroup_environment();
-	close(cg_fd);
 	return err;
 }
 
-- 
2.43.0



