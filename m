Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034079;
	b=1m1NIrKdLWvhlZKRSiTfaWTsJNQIt8Ckg3olCrY7OT0fB5+ihtwt/ybSq9+oYbMd2eQo
	 sk3Ye/iA+/VbXve+O8lyE1U7LraNGrPF1AEjtwsWi/VdkpgSenc8FjHGjtJOSTSCJDj9X
	 SVjxqvhdwkWXKKN5cOtPc6aStaaojK0SaZzIi3Cw+KZgT/GJ2FENEXBwwx1wYj/Wi38n1
	 Ax/jARiiobaKW0h/zFWRkv8JFcW9qH48Qo3vvAmWvieFcBUxH8jHbmLEIifF+BiuKez9q
	 oUIDlhzqlTLeRZqAJCFrjLN/oToOeRhZXzqpUQkUTZYSQvqDhaJ5pNZpKSyRPE9a1mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZNbiriQTldJX1idC8fz2lmq3HhJTONeJl9gLfRZuU4=;
	b=CGlLNX6DRZCaEqCEB3zVQmsHuqc7PFZmvRR25WsMU7Mo9b+M5hiXzFzJ7CzaJ8qGdelt
	 0L/PY/i4k5uPWFDIHBHEi2SLRgKNQr70OFDjNhQ5iRGZ+27hTFM1Ky4yJvMPYIQQEx9qG
	 uNPiPT79esKMgy77VqEd53+ZbM9WX2g6X0Q54IfGZPUc+hdxFj/uBYWXzu6ohGLjJ1fyK
	 lezyX7eLk1T8avsIumfpBW4+U8w2eAiQ9IDdAI3miUKWey4ljSbAcm4LUzlo32Xh92PhX
	 ICbqfK3rOl4l5HzflzvEekBkdGUNB6qxSy6o1XoPtUacLWXxreOeb2e4oStOHK19yow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPAn2A+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2127A606A33D;
	Wed, 18 Nov 2026 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPAn2A+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799001F000C5;
	Wed, 18 Nov 2026 20:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034079;
	bh=qZNbiriQTldJX1idC8fz2lmq3HhJTONeJl9gLfRZuU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPAn2A+iARKLahQdJz8SAvOdLjfNgYVHsQoSZVFfaiCkgHAEyQR//FRWvk9hvZQDt
	 vgfueRvefI7ZIwdAglqdBe5sfd5anWzEgbereEZRpbWaB6+hsuAnekGqe2OPwsH9xk
	 D4QgIpSvB19788pOFi+xuAsV8ySUmWIVKjrd3Uvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0241/3318] selftests/ftrace: Force C locale in ftracetest
Date: Wed, 18 Nov 2026 15:14:23 +0100
Message-ID: <20261118150322.359975567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit c13fcd3951dcc19524ce0b3e852844b16cd32b22 ]

Some ftracetest test cases parse command output by matching English
field names. Tools such as readelf may localize their output via
gettext, while ftracetest currently inherits the user locale from
the environment.

If a translated field name is printed, parsing can fail even though
the tested kernel behavior is unchanged. For example, add_remove_uprobe
can fail to find the ELF entry point and then write a uprobe event with
a missing offset.

Export LC_ALL=C in the top-level ftracetest runner so every test case
gets stable command output by default.

Link: https://lore.kernel.org/all/20260807081512.2974757-2-qirui.001@bytedance.com/

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index c778d4dcc17e5..22d0f5ec9bd28 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -7,6 +7,9 @@
 #  Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
 #
 
+# Keep command output parsing stable regardless of the user's locale.
+export LC_ALL=C
+
 usage() { # errno [message]
 [ ! -z "$2" ] && echo $2
 echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
-- 
2.53.0



