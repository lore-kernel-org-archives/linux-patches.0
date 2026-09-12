Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04F525B0AA;
	Sat, 12 Sep 2026 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207869; cv=none; b=qJjGBmIH17+lbVMqm0o01g3nFJ8QOKXAe6XlXkxjZE+5wdCihiFlc6i8Kh4BJ+q/gRxEgdA3JEMoTHSvX9SJcxVEAl9Ziwpg5H2QhRXlD3EWSjHE5HZcEL1ceflD2mhvrJDrBQpNGeAxr0y+dSfukpsrNs9ZY5Cjl4xJOo5H7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207869; c=relaxed/simple;
	bh=w2peagsUgAOKuedPHOBwza2N9SK16zSacBWjkqjrmqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BaZRXDm50zavHiY/eezzfN6kQpsOV+N4VZAZhbO+u/jm6WFnBjeGoyYDNdIfUMJlgrimkwWwlUmcXk7Wvs6T7GD0wPCC+8AieRF/UcRYo+au+bW0UnFVBAsGFtFJ7yDj/gjou54F2JA6E3uA4B9KHnCRqPOt9vgdOMRZPGBdxdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZP1wD6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZP1wD6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB0E1F000FF;
	Sat, 12 Sep 2026 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207868;
	bh=rGuofXSpMPppCHS6clqIbN/nryKSTCJMMQJko95MkRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZP1wD6Ryl5WpJpWk+iUVU/KDka6+ZQT1Nirbo1WOebdT7QO7BNlxpB2tl36RHWD/
	 V5a0GkT96Z1e00rPEHXVO6pL2IEuPGi3uH+y9nl/r8X6LfmM9Nbfdvb15C7A/C1rKf
	 pOIQV5OxP7D+hykV8eTNHGm94MaGPwiHoUlsMRKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0499/1518] libbpf: Search /lib64 and /lib in resolve_full_path()
Date: Sat, 12 Sep 2026 08:44:28 +0200
Message-ID: <20260912065634.732676360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 7b5ae0481efdac040cea72b4fabd1398109f975b ]

attach_probe/uprobe-lib and uprobe_autoattach selftests fail with "failed
to resolve full path for libc.so.6" on older non-usrmerged distros, where
libc.so.6 lives under a top-level /lib64 or /lib rather than /usr/lib64 or
/usr/lib. Add /lib64:/lib to the search paths, alongside the existing
/usr/lib64:/usr/lib and Debian multiarch entries.

Fixes: 1ce3a60e3c28 ("libbpf: auto-resolve programs/libraries when necessary for uprobes")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260720-selftests-bpf_fixes-v2-3-b450eda93dfe@suse.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3baa6025ecba0..94ee5f52b8661 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12148,13 +12148,14 @@ static const char *arch_specific_lib_paths(void)
 /* Get full path to program/shared library. */
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
-	const char *search_paths[3] = {};
+	const char *search_paths[4] = {};
 	int i, perm;
 
 	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
+		search_paths[3] = "/lib64:/lib";
 		perm = R_OK;
 	} else {
 		search_paths[0] = getenv("PATH");
-- 
2.53.0



