Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B479C97D
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 21:49:07 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230330214200usoutp02462ea44fb1a7afcb25704602e53711e4~RUGKUlCqm0586405864usoutp02W;
	Thu, 30 Mar 2023 21:42:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230330214200usoutp02462ea44fb1a7afcb25704602e53711e4~RUGKUlCqm0586405864usoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1680212520;
	bh=Biy0jl9qLbwZXRDPrFyYv6C5iXTSr8418v34owutgqA=;
	h=From:To:CC:Subject:Date:References:From;
	b=cjdYAiJRppQOZmd59TXKjvQFvz1nBe6SOdE5ZMYkVBlob6rlL8yajVB1yKQSLM49A
	 JaglYgr2qku8a41FcBkQvEZjRevDapaxf/agLMhxyUioFCHJvzmUQz1cbkd6cSDagq
	 +1X74vZO2jMQUwPU2++8MeRg9u/RnnSEL6UDC6uw=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230330214200uscas1p2ea443751c7e1e6ce280bc4cec0444f3c~RUGKOQhWE3235232352uscas1p22;
	Thu, 30 Mar 2023 21:42:00 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id E0.92.09547.82206246; Thu,
	30 Mar 2023 17:42:00 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
	[203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230330214200uscas1p12bfa2436a1a5b2fc7650d7671b628d8a~RUGKDBrHy0941309413uscas1p1C;
	Thu, 30 Mar 2023 21:42:00 +0000 (GMT)
X-AuditID: cbfec370-a01fe7000000254b-5f-64260228e6d8
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 50.49.09579.72206246; Thu,
	30 Mar 2023 17:41:59 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Thu, 30 Mar 2023 14:41:56 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
	SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Thu,
	30 Mar 2023 14:41:56 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: "mcgrof@kernel.org" <mcgrof@kernel.org>, Fan Ni <fan.ni@samsung.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Adam Manzanares
	<a.manzanares@samsung.com>
Subject: [PATCH] build_qemu: Build and use target arch qemu
Thread-Topic: [PATCH] build_qemu: Build and use target arch qemu
Thread-Index: AQHZY1ByaDRdvY6Or0Kxsh+yWFHsSA==
Date: Thu, 30 Mar 2023 21:41:56 +0000
Message-ID: <20230330214146.614373-1-a.manzanares@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWy7djX87oaTGopBlO3cVn8XLaK3eLGhKeM
	FpdPXGJ0YPbYtKqTzePF5pmMAUxRXDYpqTmZZalF+nYJXBkvDm1kL5itULG56w9zA+Mm6S5G
	Tg4JAROJ93+nM3UxcnEICaxklHjZP5kdwmllkpi4azobTFXPmjlQibWMEkvPfmWBcD4xSsy4
	/J8NwlnGKNG3oI8FpIVNwEDi9/GNzCC2iECpxPauH2BxZoFUiW2nfoCNFRawlti97gxUjYPE
	7f9zWSFsPYnP8y4DHcXBwSKgKvHuiDJImFfATuLD7tlgrYwCYhLfT61hghgpLnHryXwmiEsF
	JRbN3sMMYYtJ/Nv1EOoDRYn731+yQ9TrSdyYOoUNwtaWWLbwNTPEfEGJkzOfsEDUS0ocXHED
	7EkJgZ/sEidfL2GHSLhIrDt2jxHClpb4e3cZ1OJ8iV1tV6AWV0hcfd0NtdhaYuGf9VCH8kn8
	/fWIEeQvCQFeiY42oQmMSrOQvDALyXmzkJw3C8l5CxhZVjGKlxYX56anFhvnpZbrFSfmFpfm
	pesl5+duYgSmkNP/DhfsYLx166PeIUYmDsZDjBIczEoivIXGqilCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ1tTyYLCaQnlqRmp6YWpBbBZJk4OKUamBbZObVHGtya98i6XtPzPtPqTy5MU48K
	7gyf+a+7+iL/vXM9ItavmR7t0a9Pv7EmxHLK9aeX+z+VzL5aGc+oGbxjAlfHStWdDlpxjct1
	jIKSnwW2xtlfvrbceGbF4lbdysVXlxnnfTofdHSfY1SUhul+v2P3+92k689H62atzJzMmifP
	NjdRsNv6+b2DSRIr/bbu1W1rONm1ROy2TvbLTJv1B1tjeedqXX5wImf90uPf1z6zspVKDFp/
	RS/k3dVX2ovyQgvueZj5vlFysFlc5nh4jhlPP1eMkMn7+IVq3v8DUz/nu1bJbOSOvvHmiV+j
	24TAdX6L7goY3bH7VnduG5Oc2P8f9xyl1a4fV55Uo8RSnJFoqMVcVJwIAAPB97CQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWS2cA0UVedSS3FoLvRwuLnslXsFjcmPGW0
	uHziEqMDs8emVZ1sHi82z2QMYIrisklJzcksSy3St0vgynhxaCN7wWyFis1df5gbGDdJdzFy
	ckgImEj0rJnD3sXIxSEksJpR4uny/UwQzidGidVzNkA5yxglWm9PZgRpYRMwkPh9fCMziC0i
	UCqxvesHC4jNLJAqse3UDzYQW1jAWmL3ujNQNQ4St//PZYWw9SQ+z7sMNJSDg0VAVeLdEWWQ
	MK+AncSH3bPBWhkFxCS+n1rDBDFSXOLWk/lMEJcKSCzZc54ZwhaVePn4HyuErShx//tLdoh6
	PYkbU6ewQdjaEssWvmaGmC8ocXLmExaIekmJgytusExgFJ2FZMUsJO2zkLTPQtK+gJFlFaN4
	aXFxbnpFsVFearlecWJucWleul5yfu4mRmDcnP53OHoH4+1bH/UOMTJxMB5ilOBgVhLhLTRW
	TRHiTUmsrEotyo8vKs1JLT7EKM3BoiTO+zJqYryQQHpiSWp2ampBahFMlomDU6qBaYf5Kun8
	2T57VT+9ceLikpr/ulbmocGb5DOsa6Zv8JVISnmukmqXx3dIxq5w1pz0WMFf2Str3HmCHqrv
	V7ugvFSW2f9bxIwfm0xMRSd/tz0fceykdPrxV88N/7z//vHGGqENwXPXfOf5lOs4Lzv4d+Z2
	Ket1C3L4UzasWFr3u0z7lWO0SJNKyMzOfXfcn9+fWuvMtFhCmKl7YmHb0s/T92XYPOq/YK8t
	1sZkfIo79cyhf29OOAef2rzgzjTHIjsB8x/JMi2zv2efuWKt3Sx3YcE2ftFzl7s5Lz6q41I4
	dPb9fjvWG6GPOZUkN4ow8jWz33V7zLpR79R3y70Z9z+UXoyVCuSxdnqmKvNRd+fMr0osxRmJ
	hlrMRcWJAPb0QCQKAwAA
X-CMS-MailID: 20230330214200uscas1p12bfa2436a1a5b2fc7650d7671b628d8a
CMS-TYPE: 301P
X-CMS-RootMailID: 20230330214200uscas1p12bfa2436a1a5b2fc7650d7671b628d8a
References: <CGME20230330214200uscas1p12bfa2436a1a5b2fc7650d7671b628d8a@uscas1p1.samsung.com>

Assume the target Linux architecture is also the assumed architecture
to build and use for QEMU

Time to build qemu on an x86_64 system before this patch:

real    6m45.901s
user    105m18.576s
sys     12m16.630s

Time to build qmeu on the same x86_64 system after applying this patch:

real    2m11.166s
user    14m32.722s
sys     2m19.130s

Signed-off-by: Adam Manzanares <a.manzanares@samsung.com>
---
 Makefile.build_qemu                          |  8 ++++++++
 playbooks/roles/build_qemu/defaults/main.yml |  1 +
 playbooks/roles/build_qemu/tasks/main.yml    |  2 +-
 scripts/gen-nodes.Makefile                   | 13 +++++++++++++
 vagrant/Kconfig                              |  5 +++++
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Makefile.build_qemu b/Makefile.build_qemu
index 68faf8e..b44464d 100644
--- a/Makefile.build_qemu
+++ b/Makefile.build_qemu
@@ -11,6 +11,14 @@ QEMU_BUILD_SETUP_ARGS +=3D qemu_git=3D$(QEMU_GIT)
 QEMU_BUILD_SETUP_ARGS +=3D qemu_data=3D\"$(QEMU_DATA)\"
 QEMU_BUILD_SETUP_ARGS +=3D qemu_version=3D'$(QEMU_GIT_VERSION)'
=20
+ifeq (y,$(CONFIG_TARGET_ARCH_X86_64))
+QEMU_BUILD_SETUP_ARGS +=3D qemu_target=3D"x86_64-softmmu"
+endif
+
+ifeq (y,$(CONFIG_TARGET_ARCH_PPC64LE))
+QEMU_BUILD_SETUP_ARGS +=3D qemu_target=3D"ppc64-softmmu"
+endif
+
 qemu: $(KDEVOPS_EXTRA_VARS)
 	@$(Q)ansible-playbook --connection=3Dlocal \
 		--inventory localhost, \
diff --git a/playbooks/roles/build_qemu/defaults/main.yml b/playbooks/roles=
/build_qemu/defaults/main.yml
index bd7c258..006d669 100644
--- a/playbooks/roles/build_qemu/defaults/main.yml
+++ b/playbooks/roles/build_qemu/defaults/main.yml
@@ -11,3 +11,4 @@ qemu_data: "{{ data_path }}/qemu"
 qemu_git: "https://github.com/qemu/qemu.git"
 qemu_version: "v7.2.0-rc4"
 qemu_build_dir: "{{ qemu_data }}/build"
+qemu_target: "x86_64-softmmu"
diff --git a/playbooks/roles/build_qemu/tasks/main.yml b/playbooks/roles/bu=
ild_qemu/tasks/main.yml
index 445fdb6..0488ddd 100644
--- a/playbooks/roles/build_qemu/tasks/main.yml
+++ b/playbooks/roles/build_qemu/tasks/main.yml
@@ -66,7 +66,7 @@
     - build_qemu_now|bool
=20
 - name: run configure for qemu
-  command: "./configure"
+  command: "./configure --target-list=3D{{ qemu_target }}"
   tags: [ 'qemu', 'configure' ]
   args:
     chdir: "{{ qemu_data }}"
diff --git a/scripts/gen-nodes.Makefile b/scripts/gen-nodes.Makefile
index 760316d..146af46 100644
--- a/scripts/gen-nodes.Makefile
+++ b/scripts/gen-nodes.Makefile
@@ -9,7 +9,20 @@ GEN_NODES_EXTRA_ARGS +=3D vagrant_box_version=3D'$(subst "=
,,$(CONFIG_VAGRANT_BOX_VER
 GEN_NODES_EXTRA_ARGS +=3D vagrant_vcpus_count=3D'$(subst ",,$(CONFIG_VAGRA=
NT_VCPUS_COUNT))'
 GEN_NODES_EXTRA_ARGS +=3D vagrant_mem_mb=3D'$(subst ",,$(CONFIG_VAGRANT_ME=
M_MB))'
=20
+ifeq (y,$(CONFIG_QEMU_BUILD))
+
+  ifeq (y,$(CONFIG_TARGET_ARCH_X86_64))
+  GEN_NODES_EXTRA_ARGS +=3D qemu_bin_path=3D'$(subst ",,$(CONFIG_QEMU_INST=
ALL_DIR_LIBVIRT))/qemu-system-x86_64'
+  endif
+
+  ifeq (y,$(CONFIG_TARGET_ARCH_PPC64LE))
+  GEN_NODES_EXTRA_ARGS +=3D qemu_bin_path=3D'$(subst ",,$(CONFIG_QEMU_INST=
ALL_DIR_LIBVIRT))/qemu-system-ppc64'
+  endif
+
+else
 GEN_NODES_EXTRA_ARGS +=3D qemu_bin_path=3D'$(subst ",,$(CONFIG_QEMU_BIN_PA=
TH))'
+endif
+
=20
 GEN_NODES_EXTRA_ARGS +=3D libvirt_uri=3D'$(subst ",,$(CONFIG_LIBVIRT_URI))=
'
 GEN_NODES_EXTRA_ARGS +=3D libvirt_system_uri=3D'$(subst ",,$(CONFIG_LIBVIR=
T_SYSTEM_URI))'
diff --git a/vagrant/Kconfig b/vagrant/Kconfig
index 13fd6c4..6573d6f 100644
--- a/vagrant/Kconfig
+++ b/vagrant/Kconfig
@@ -258,6 +258,11 @@ config QEMU_BIN_PATH_LIBVIRT
 	default "/usr/local/bin/qemu-system-x86_64" if QEMU_USE_DEVELOPMENT_VERSI=
ON
 	default "/usr/bin/qemu-system-x86_64" if !QEMU_USE_DEVELOPMENT_VERSION
=20
+config QEMU_INSTALL_DIR_LIBVIRT
+	string "Path to install QEMU "
+	default "/usr/local/bin" if QEMU_USE_DEVELOPMENT_VERSION
+	default "/usr/bin" if !QEMU_USE_DEVELOPMENT_VERSION
+
 config QEMU_VIRSH_CAN_SUDO
 	bool
 	default $(shell, ./scripts/get_libvirsh_can_sudo.sh)
--=20
2.39.0
