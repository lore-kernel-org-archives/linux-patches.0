Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453541DF258;
	Tue, 11 Nov 2025 00:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822675; cv=none; b=m8SWhkj7NRA6mrtA6vlZfiWBOZZliI73ahCfjV5IoK7pA0oYk5Ub06BjtY+4+96Ie33tGSz08Mvnx0ZRKNBb9ONv2HDIR8maewUamnIDnJTyWxfMQfi8TCela9JT6UX4EEwHW3+hK+hD1WJilCzLRCjpyZSg8G/pa7EIJZDqHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822675; c=relaxed/simple;
	bh=8OxEqz7MKXRGAFsKN3Dv4f1FZCxKOhkiMkdYd/OLnE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJ5qEDnpog0OZCVO/Vaz2yhLT8YvV8jUS/0wWlF4Ermk8t7c7BjUha0hINDxaMzjYeUoJOzuFcjk5PwcQVlnKx8QwmfwA0OvAR7V5wxLmGGAGJDHdwkbo+R+OMWivdgpN0NL6tkNB4fVFZesVPnQi+rhjmlHm73KP4meMqt5BO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Soi2rYVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Soi2rYVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E27C4AF0B;
	Tue, 11 Nov 2025 00:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822675;
	bh=8OxEqz7MKXRGAFsKN3Dv4f1FZCxKOhkiMkdYd/OLnE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Soi2rYVQSEdewwjDx2bdadu9Rn0320zwUusBz0csWcyU+hpXIYc5jFx8bwrrGvJ9a
	 0MI9SXLDBH77Ue0GPPBR/bnD8JpOszDIVeolDL7BYMJ0djBsNTKeZjqE/L7FE7F89a
	 w6kmh71AXaRb5fimpPH8t0aGNYBdsD8A6YhDAKus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 146/849] selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh
Date: Tue, 11 Nov 2025 09:35:16 +0900
Message-ID: <20251111004539.939586398@linuxfoundation.org>
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

[ Upstream commit 2a912258c90e895363c0ffc0be8a47f112ab67b7 ]

Currently, even if some subtests fails, the end result will still yield
"ok 1 selftests: bpf: test_xsk.sh". Fix it by exiting with 1 if there are
any failures.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-test_xsk_ret-v1-1-e6656c01f397@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 65aafe0003db0..62db060298a4a 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -241,4 +241,6 @@ done
 
 if [ $failures -eq 0 ]; then
         echo "All tests successful!"
+else
+	exit 1
 fi
-- 
2.51.0



